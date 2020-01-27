//
//  ServicesFactory.swift
//  ServiceKit
//
//  Created by Dre on 23.01.2020.
//

import Foundation
import CoreKit
import PersistentStorageKit

public final class ServicesFactory {

    public static func makeSearchService() -> SearchServiceProtocol {
        return SearchService(httpClient: HTTPClientBuilder.makeHTTPClient())
    }

    public static func makeEventsService() -> EventsServiceProtocol {
        return EventsService(httpClient: HTTPClientBuilder.makeHTTPClient())
    }

    public static func makeEventsRepository(service: EventsServiceProtocol,
                                            storage: PersistentStorage) -> EventsRepositoryProtocol
    {
        return EventsRepository(eventsService: service, storage: storage)
    }

}
