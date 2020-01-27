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
            .on(value: { [weak self] events in
                let events = events.map {
                    Event(id: $0.id,
                          name: $0.name,
                          type: $0.type,
                          date: $0.date,
                          city: $0.city,
                          popularity: $0.popularity,
                          artistID: artistID)
                }
                self?.storage.save(objects: events)
            })
            .flatMapError { [weak self] error -> SignalProducer<[Event], Error> in
                guard let self = self else { return .empty }
                if error.isNotConnectedToInternet {
                    return self.fetchSavedEvents(forArtistID: artistID)
                        .promoteError(Error.self)
                }
                return SignalProducer(error: error)
            }
    }

    // MARK: - Private Methods
    private func fetchSavedEvents(forArtistID artistID: Int) -> SignalProducer<[Event], Never> {
        let fetchSavedEvents = SignalProducer<[Event], Never> { [weak self] () -> [Event] in
            guard let self = self else { return [] }
            let artistKey = StorageKey(name: Event.Field.artistID, value: artistID)
            let sort = NSSortDescriptor(key: Event.Field.date, ascending: false)

            return self.storage.objects(byKey: artistKey, sorting: sort)
        }

        return fetchSavedEvents
            .start(on: QueueScheduler(qos: .userInitiated))
    }

}
