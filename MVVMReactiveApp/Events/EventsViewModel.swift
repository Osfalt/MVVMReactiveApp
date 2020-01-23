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
    var artist: Property<Artist> { get }
    var events: Property<[Event]> { get }
    var eventsAreLoading: Signal<Bool, Never> { get }

}

// MARK: - Implementation
final class EventsViewModel: EventsViewModelProtocol {

    // MARK: - Internal Properties
    let artist: Property<Artist>

    var events: Property<[Event]> {
        return Property(eventsProperty)
    }

    var eventsAreLoading: Signal<Bool, Never> {
        return eventsAreLoadingPipe.output
    }

    var pullToRefreshDidTrigger: Signal<Void, Never>.Observer {
        return pullToRefreshDidTriggerPipe.input
    }

    // MARK: - Private Properties
    private let eventsProperty = MutableProperty<[Event]>([])
    private let eventsAreLoadingPipe = Signal<Bool, Never>.pipe()
    private let pullToRefreshDidTriggerPipe = Signal<Void, Never>.pipe()

    private lazy var fetchEvents = Action<Int, [Event], Error> { [weak self] artistID -> SignalProducer<[Event], Error> in
        guard let self = self else { return .empty }
        return self.eventsService.upcomingEvents(forArtistID: artistID)
    }

    private let router: EventsRouterProtocol
    private let eventsService: EventsServiceProtocol

    // MARK: - Init
    init(router: EventsRouterProtocol, eventsService: EventsServiceProtocol, artist: Artist) {
        self.router = router
        self.eventsService = eventsService
        self.artist = Property(value: artist)
    }

    // MARK: - Internal Methods
    func viewDidLoad() {
        eventsAreLoadingPipe.input <~ fetchEvents.isExecuting
        pullToRefreshDidTriggerPipe.output.observeValues { [weak self] in self?.performFetchEvents() }

        performFetchEvents()
    }

    // MARK: - Private Methods
    private func performFetchEvents() {
        fetchEvents
            .apply(artist.value.id)
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
