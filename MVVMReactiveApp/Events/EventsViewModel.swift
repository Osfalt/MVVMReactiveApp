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
        static let firstPage = 1
        static let defaultPerPage = 30
    }

    private typealias FetchParams = (artistID: Int, page: Int)

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
                self?.page != Constant.firstPage
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

    private lazy var fetchEvents = Action<FetchParams, [Event], Error> { [weak self] artistID, page in
        guard let self = self else { return .empty }
        return self.eventsService
            .pastEvents(forArtistID: artistID, ascending: false, page: page, perPage: Constant.defaultPerPage)
            .observe(on: UIScheduler())
    }

    private lazy var downloadArtistPhoto = Action<URL, UIImage?, Error> { [weak self] photoURL in
        guard let self = self else { return .empty }
        return self.imageLoader
            .loadImage(at: photoURL, size: Constant.defaultPhotoSize)
            .map { $0.image }
            .observe(on: UIScheduler())
    }

    private let router: EventsRouterProtocol
    private let eventsService: EventsServiceProtocol
    private let imageLoader: ImageLoaderProtocol

    private var page = Constant.firstPage
    private var isLastPage = false

    private lazy var eventDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM yyyy"
        return formatter
    }()

    // MARK: - Init
    init(router: EventsRouterProtocol,
         eventsService: EventsServiceProtocol,
         imageLoader: ImageLoaderProtocol,
         artist: Artist)
    {
        self.router = router
        self.eventsService = eventsService
        self.imageLoader = imageLoader
        self.artistProperty = Property(value: artist)
        setupModelsMapping()
    }

    // MARK: - Internal Methods
    func viewDidLoad() {
        pullToRefreshDidTriggerPipe.output.observeValues { [weak self] in
            guard let self = self else { return }
            self.page = Constant.firstPage
            self.isLastPage = false
            self.startFetchEvents(page: self.page)
            self.startDownloadArtistPhoto()
        }

        loadMoreDidTriggerPipe.output
            .debounce(0.1, on: QueueScheduler.main)
            .observeValues { [weak self] in
                guard let self = self,
                    !self.fetchEvents.isExecuting.value,
                    !self.isLastPage else {
                        return
                }
                self.startFetchEvents(page: self.page)
            }

        startDownloadArtistPhoto()
        startFetchEvents(page: page)
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
        downloadArtistPhoto
            .apply(artistProperty.value.avatarURL())
            .mapError { $0.underlyingError }
            .observe(on: UIScheduler())
            .startWithFailed { [weak self] error in
                self?.router.show(error: error)
            }
    }

    private func startFetchEvents(page: Int) {
        let fetchParams = (artistID: artistProperty.value.id, page: page)
        fetchEvents
            .apply(fetchParams)
            .mapError { $0.underlyingError }
            .observe(on: UIScheduler())
            .startWithResult { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let events):
                    self.handle(events: events)

                case .failure(let error):
                    self.router.show(error: error)
                }
            }
    }

    private func handle(events: [Event]) {
        if page == Constant.firstPage {
            eventsProperty.value = []
        }

        eventsProperty.value += events
        isLastPage = events.isEmpty
        page += 1
    }

}
