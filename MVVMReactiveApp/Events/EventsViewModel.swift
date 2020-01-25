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

    // in
    var pullToRefreshDidTrigger: Signal<Void, Never>.Observer { get }

    func viewDidLoad()

    // out
    var artistName: Property<String> { get }
    var artistPhoto: Signal<UIImage?, Never> { get }
    var artistPhotoIsLoading: Signal<Bool, Never> { get }
    var events: Property<[EventCellModel]> { get }
    var eventsAreLoading: Signal<Bool, Never> { get }

}

// MARK: - Implementation
final class EventsViewModel: EventsViewModelProtocol {

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

    var pullToRefreshDidTrigger: Signal<Void, Never>.Observer {
        return pullToRefreshDidTriggerPipe.input
    }

    // MARK: - Private Properties
    private let artistProperty: Property<Artist>

    private let eventsProperty = MutableProperty<[Event]>([])
    private let eventsCellModelsProperty = MutableProperty<[EventCellModel]>([])

    private let pullToRefreshDidTriggerPipe = Signal<Void, Never>.pipe()

    private lazy var fetchEvents = Action<Int, [Event], Error> { [weak self] artistID in
        guard let self = self else { return .empty }
        return self.eventsService
            .pastEvents(forArtistID: artistID, ascending: false)
            .observe(on: UIScheduler())
    }

    private lazy var downloadArtistPhoto = Action<URL, UIImage?, Error> { [weak self] photoURL in
        guard let self = self else { return .empty }
        return self.imageLoader
            .loadImage(with: photoURL)
            .map { $0.image }
            .observe(on: UIScheduler())
    }

    private let router: EventsRouterProtocol
    private let eventsService: EventsServiceProtocol
    private let imageLoader: ImageLoaderProtocol

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
        pullToRefreshDidTriggerPipe.output.observeValues { [weak self] in self?.startFetchEvents() }

        startDownloadArtistPhoto()
        startFetchEvents()
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
            .apply(artistProperty.value.avatarURL(size: .large))
            .mapError { $0.underlyingError }
            .observe(on: UIScheduler())
            .startWithFailed { [weak self] error in
                self?.router.show(error: error)
            }
    }

    private func startFetchEvents() {
        fetchEvents
            .apply(artistProperty.value.id)
            .mapError { $0.underlyingError }
            .observe(on: UIScheduler())
            .startWithResult { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let events):
                    self.eventsProperty.value = events

                case .failure(let error):
                    self.router.show(error: error)
                }
            }
    }

}
