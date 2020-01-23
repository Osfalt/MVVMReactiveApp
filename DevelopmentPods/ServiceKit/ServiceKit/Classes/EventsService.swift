//
//  EventsService.swift
//  ServiceKit
//
//  Created by Dre on 23.01.2020.
//

import Foundation
import ReactiveSwift
import CoreKit
import APIKit

// MARK: - Protocol
public protocol EventsServiceProtocol: AnyObject {

    func upcomingEvents(forArtistID id: Int) -> SignalProducer<[Event], Error>
    func pastEvents(forArtistID id: Int, ascending: Bool) -> SignalProducer<[Event], Error>

}

// MARK: - Implementation
final class EventsService: EventsServiceProtocol {

    // MARK: - Private Types
    private enum EventType {
        case upcoming
        case past(ascending: Bool)
    }

    // MARK: - Private Properties
    private let httpClient: HTTPClient

    // MARK: - Init
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }

    // MARK: - Internal Methods
    func upcomingEvents(forArtistID id: Int) -> SignalProducer<[Event], Error> {
        return events(type: .upcoming, forArtistID: id)
    }

    func pastEvents(forArtistID id: Int, ascending: Bool) -> SignalProducer<[Event], Error> {
        return events(type: .past(ascending: ascending), forArtistID: id)
    }

    // MARK: - Private Methods
    private func events(type: EventType, forArtistID id: Int) -> SignalProducer<[Event], Error> {
        guard let url = eventsURL(type: type, forArtistID: id) else {
            return .init(error: URLError(.badURL))
        }

        return httpClient
            .requestData(URLRequest(url: url))
            .attemptMap { (data, response) -> CollectionResponse<Event> in
                return try JSONDecoder().decode(CollectionResponse<Event>.self, from: data)
            }
            .flatMap(.latest) { collectionResponse -> SignalProducer<[Event], Error> in
                let events = collectionResponse.results
                return .init(value: events)
            }
    }

    private func eventsURL(type: EventType, forArtistID id: Int) -> URL? {
        switch type {
        case .upcoming:
            return URLBuilder.upcomingEvents(artistID: id).url

        case .past(let ascending):
            return URLBuilder.pastEvents(artistID: id, ascending: ascending).url
        }
    }

}
