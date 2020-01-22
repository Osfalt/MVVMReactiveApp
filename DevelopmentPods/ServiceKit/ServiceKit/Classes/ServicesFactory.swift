//
//  ServicesFactory.swift
//  ServiceKit
//
//  Created by Dre on 23.01.2020.
//

import Foundation
import APIKit

public final class ServicesFactory {

    public static func makeSearchService() -> SearchServiceProtocol {
        return SearchService(httpClient: HTTPClientBuilder.makeHTTPClient())
    }

    public static func makeEventsService() -> EventsServiceProtocol {
        return EventsService(httpClient: HTTPClientBuilder.makeHTTPClient())
    }

}
