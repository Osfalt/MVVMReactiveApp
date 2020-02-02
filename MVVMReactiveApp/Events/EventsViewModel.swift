//
//  EventsViewModel.swift
//  MVVMReactiveApp
//
//  Created by Dre on 21.01.2020.
//  Copyright © 2020 Andrey Sidorovnin. All rights reserved.
//

import Foundation
import ReactiveSwift
import CoreKit
import ServiceKit

// MARK: - Protocol
protocol EventsViewModelProtocol {

    // output
    var artistName: Property<String> { get }
    var artistPhoto: Signal<UIImage?, Never> { get }
    var artistPhotoIsLoading: Signal<Bool, Never> { get }
    var events: Property<[EventCellModel]> { get }
    var eventsAreLoading: Signal<Bool, Never> { get }
    var eventsAreLoadingMore: Signal<Bool, Never> { get }

    // input
    var pullToRefreshDidTrigger: Signal<Void, Never>.Observer { get }
    var loadMoreDidTrigger: Signal<Void, Never>.Observer { get }

    func viewDidLoad()

}

// MARK: - Implementation
final class EventsViewModel: EventsViewModelProtocol {

    // MARK: - Private Types
    private enum Constant {
        static let defaultPhotoSize = CGSize(width: 70, height: 70)
    }

    private typealias EventsFetchResult = (events: [Event], isFromCache: Bool)
    private typealias FetchParams = (artistID: Int, page: Int, perPage: Int)

    // MARK: - Internal Properties
    var artistName: Property<String> {
        return artistProperty.map { $0.name }
    }

    var artistPhoto: Signal<UIImage?, Never> {
        return downloadArtistPhoto.values
    }

    var artistPhotoIsLoading: Signal<Bool, Never> {
        return downloadArtistPhoto.isExecuting.signal
    }

    var events: Property<[EventCellModel]> {
        return Property(eventsCellModelsProperty)
    }

    var eventsAreLoading: Signal<Bool, Never> {
        return fetchEvents.isExecuting.signal
    }

    var eventsAreLoadingMore: Signal<Bool, Never> {
        return fetchEvents.isExecuting.signal
            .filter { [weak self] _ in
                self?.paginator.isFirstPage != true
            }
    }

    var pullToRefreshDidTrigger: Signal<Void, Never>.Observer {
        return pullToRefreshDidTriggerPipe.input
    }

    var loadMoreDidTrigger: Signal<Void, Never>.Observer {
        return loadMoreDidTriggerPipe.input
    }

    // MARK: - Private Properties
    private let artistProperty: Property<Artist>

    private let eventsProperty = MutableProperty<[Event]>([])
    private let eventsCellModelsProperty = MutableProperty<[EventCellModel]>([])

    private let pullToRefreshDidTriggerPipe = Signal<Void, Never>.pipe()
    private let loadMoreDidTriggerPipe = Signal<Void, Never>.pipe()

    private lazy var fetchEvents = Action<FetchParams, EventsFetchResult, Error> { [weak self] artistID, page, perPage in
        guard let self = self else { return .empty }
        return self.eventsRepository
            .pastEvents(forArtistID: artistID, ascending: false, page: page, perPage: perPage)
            .observe(on: UIScheduler())
    }

    private lazy var downloadArtistPhoto = Action<URL, UIImage?, Error> { [weak self] photoURL in
        guard let self = self else { return .empty }
        return self.imageLoader
            .loadImage(at: photoURL, size: Constant.defaultPhotoSize)
            .map { $0.image }
            .observe(on: UIScheduler())
    }

    private var fetchEventsDisposable: Disposable?
    private var downloadArtistPhotoDisposable: Disposable?
    private let paginator = Paginator()

    private lazy var eventDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM yyyy"
        return formatter
    }()

    // MARK: Dependencies
    private let router: EventsRouterProtocol
    private let eventsRepository: EventsRepositoryProtocol
    private let imageLoader: ImageLoaderProtocol

    // MARK: - Init & deinit
    init(router: EventsRouterProtocol,
         eventsRepository: EventsRepositoryProtocol,
         imageLoader: ImageLoaderProtocol,
         artist: Artist)
    {
        self.router = router
        self.eventsRepository = eventsRepository
        self.imageLoader = imageLoader
        self.artistProperty = Property(value: artist)
        setupModelsMapping()
    }

    deinit {
        fetchEventsDisposable?.dispose()
        downloadArtistPhotoDisposable?.dispose()
    }

    // MARK: - Internal Methods
    func viewDidLoad() {
        pullToRefreshDidTriggerPipe.output.observeValues { [weak self] in
            guard let self = self else { return }
            self.paginator.reset()
            self.startFetchEvents(page: self.paginator.page, perPage: self.paginator.perPage)
            self.startDownloadArtistPhoto()
        }

        loadMoreDidTriggerPipe.output
            .debounce(0.1, on: QueueScheduler.main)
            .observeValues { [weak self] in
                guard let self = self,
                    !self.fetchEvents.isExecuting.value,
                    !self.paginator.isLastPage else {
                        return
                }
                self.startFetchEvents(page: self.paginator.page, perPage: self.paginator.perPage)
            }

        startDownloadArtistPhoto()
        startFetchEvents(page: paginator.page, perPage: paginator.perPage)
    }

    // MARK: - Private Methods
    private func setupModelsMapping() {
        eventsCellModelsProperty <~ eventsProperty
            .map { [weak self] events -> [EventCellModel] in
                guard let self = self else { return [] }
                return events.map {
                    EventCellModel(
                        name: $0.name,
                        details: self.eventDateFormatter.string(from: $0.date) + ", " + $0.city
                    )
                }
            }
    }

    private func startDownloadArtistPhoto() {
        downloadArtistPhotoDisposable?.dispose()
        downloadArtistPhotoDisposable = downloadArtistPhoto
            .apply(artistProperty.value.avatarURL())
            .mapError { $0.underlyingError }
            .observe(on: UIScheduler())
            .start()
    }

    private func startFetchEvents(page: Int, perPage: Int) {
        fetchEventsDisposable?.dispose()
        fetchEventsDisposable = fetchEvents
            .apply((artistID: artistProperty.value.id, page: page, perPage: perPage))
            .mapError { $0.underlyingError }
            .observe(on: UIScheduler())
            .startWithResult { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let events, let isFromCache):
                    self.handle(fetchedEvents: events, isFromCache: isFromCache)

                case .failure(let error):
                    self.router.show(error: error)
                }
            }
    }

    private func handle(fetchedEvents: [Event], isFromCache: Bool) {
        if paginator.isFirstPage {
            eventsProperty.value = []
        }

        paginator.updatePage(withCurrentItemsCount: eventsProperty.value.count,
                             fetchedItemsCount: fetchedEvents.count,
                             isFromCache: isFromCache)

        if !fetchedEvents.isEmpty {
            eventsProperty.value += fetchedEvents
        }
    }

}
