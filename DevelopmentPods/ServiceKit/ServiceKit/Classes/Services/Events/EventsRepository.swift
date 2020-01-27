//
//  EventsRepository.swift
//  ServiceKit
//
//  Created by Dre on 27.01.2020.
//

import Foundation
import ReactiveSwift
import CoreKit
import APIKit
import PersistentStorageKit

// MARK: - Protocol
public protocol EventsRepositoryProtocol: AnyObject {

    func pastEvents(forArtistID artistID: Int, ascending: Bool, page: Int, perPage: Int) -> SignalProducer<[Event], Error>

}

// MARK: - Implementation
final class EventsRepository: EventsRepositoryProtocol {

    // MARK: - Private Properties
    private let eventsService: EventsServiceProtocol
    private let storage: PersistentStorage

    // MARK: - Init
    init(eventsService: EventsServiceProtocol, storage: PersistentStorage) {
        self.eventsService = eventsService
        self.storage = storage
    }

    // MARK: - Internal Methods
    func pastEvents(forArtistID artistID: Int,
                    ascending: Bool,
                    page: Int,
                    perPage: Int) -> SignalProducer<[Event], Error>
    {
        let fetchRemoteEvents = eventsService.pastEvents(forArtistID: artistID, ascending: ascending, page: page, perPage: perPage)

        return fetchRemoteEvents
            .on(value: { [weak self] loadedEvents in
                let events = loadedEvents.map { Event(from: $0, artistID: artistID) }
                self?.storage.save(objects: events)
            })
            .flatMapError { [weak self] error -> SignalProducer<[Event], Error> in
                guard let self = self else { return .empty }
                guard error.isNotConnectedToInternet else {
                    return SignalProducer(error: error)
                }

                return self.fetchSavedEvents(forArtistID: artistID, ascending: ascending, page: page, perPage: perPage)
                    .flatMap(.latest) { savedEvents -> SignalProducer<[Event], Error> in
                        savedEvents.isEmpty
                            ? SignalProducer(error: error)
                            : SignalProducer(value: savedEvents)
                    }
            }
    }

    // MARK: - Private Methods
    private func fetchSavedEvents(forArtistID artistID: Int,
                                  ascending: Bool,
                                  page: Int,
                                  perPage: Int) -> SignalProducer<[Event], Never>
    {
        let fetchSavedEvents = SignalProducer<[Event], Never> { [weak self] () -> [Event] in
            guard let self = self else { return [] }
            let artistKey = StorageKey(name: Event.Field.artistID, value: artistID)
            let sort = NSSortDescriptor(key: Event.Field.date, ascending: ascending)
            let offset = (page - 1) * perPage

            return self.storage.objects(byKey: artistKey, offset: offset, limit: perPage, sorting: sort)
        }

        return fetchSavedEvents
            .start(on: QueueScheduler(qos: .userInitiated))
    }

}

// MARK: - Private Extensions
private extension Event {

    init(from event: Event, artistID: Int) {
        self.init(id: event.id,
                  name: event.name,
                  type: event.type,
                  date: event.date,
                  city: event.city,
                  popularity: event.popularity,
                  artistID: artistID)
    }

}
