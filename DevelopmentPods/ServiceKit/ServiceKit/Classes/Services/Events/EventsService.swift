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

    func upcomingEvents(forArtistID artistID: Int, page: Int, perPage: Int) -> SignalProducer<[Event], Error>

    func pastEvents(forArtistID artistID: Int, ascending: Bool, page: Int, perPage: Int) -> SignalProducer<[Event], Error>

}

// MARK: - Implementation
final class EventsService: EventsServiceProtocol {

    // MARK: - Private Properties
    private let httpClient: HTTPClient
    private let requestBuilder: URLRequestBuilderProtocol

    // MARK: - Init
    init(httpClient: HTTPClient,
         requestBuilder: URLRequestBuilderProtocol = DefaultURLRequestBuilder())
    {
        self.httpClient = httpClient
        self.requestBuilder = requestBuilder
    }

    // MARK: - Internal Methods
    func upcomingEvents(forArtistID artistID: Int,
                        page: Int,
                        perPage: Int) -> SignalProducer<[Event], Error>
    {
        let requestInfo = EventsRequestInfo.upcoming(artistID: artistID, page: page, perPage: perPage)
        return events(requestInfo: requestInfo)
    }

    func pastEvents(forArtistID artistID: Int,
                    ascending: Bool,
                    page: Int,
                    perPage: Int) -> SignalProducer<[Event], Error>
    {
        let requestInfo = EventsRequestInfo.past(artistID: artistID, ascending: ascending, page: page, perPage: perPage)
        return events(requestInfo: requestInfo)
    }

    // MARK: - Private Methods
    private func events(requestInfo: EventsRequestInfo) -> SignalProducer<[Event], Error> {
        let request = requestBuilder.request(with: requestInfo)
        let mapper = CollectionResponseMapper<Event>()

        return httpClient
            .requestData(request)
            .attemptMap { (data, response) -> CollectionResponse<Event> in
                try mapper.map(from: data)
            }
            .flatMap(.latest) { collectionResponse -> SignalProducer<[Event], Error> in
                let events = collectionResponse.results
                return .init(value: events)
            }
    }

}
