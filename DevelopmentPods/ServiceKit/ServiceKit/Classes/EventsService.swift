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

}

// MARK: - Implementation
final class EventsService: EventsServiceProtocol {

    private let httpClient: HTTPClient

    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }

    func upcomingEvents(forArtistID id: Int) -> SignalProducer<[Event], Error> {
        guard let url = URLBuilder.upcomingEvents(artistID: id).url else {
            return .init(error: URLError(.badURL))
        }

        let request = URLRequest(url: url)

        return httpClient
            .requestData(request)
            .attemptMap { (data, response) -> CollectionResponse<Event> in
                return try JSONDecoder().decode(CollectionResponse<Event>.self, from: data)
            }
            .flatMap(.latest) { collectionResponse -> SignalProducer<[Event], Error> in
                let events = collectionResponse.results
                return .init(value: events)
            }
    }

}
