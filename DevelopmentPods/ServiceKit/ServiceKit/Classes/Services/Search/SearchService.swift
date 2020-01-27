//
//  SearchService.swift
//  ServiceKit
//
//  Created by Dre on 18.01.2020.
//

import Foundation
import ReactiveSwift
import CoreKit
import APIKit

// MARK: - Protocol
public protocol SearchServiceProtocol: AnyObject {

    func searchArtists(query: String) -> SignalProducer<[Artist], Error>
    
}

// MARK: - Implementation
final class SearchService: SearchServiceProtocol {

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
    func searchArtists(query: String) -> SignalProducer<[Artist], Error> {
        guard !query.isEmpty else {
            return .init(value: [])
        }

        let requestInfo = SearchRequestInfo.artists(query: query)
        let request = requestBuilder.request(with: requestInfo)
        let mapper = CollectionResponseMapper<Artist>()

        return httpClient
            .requestData(request)
            .attemptMap { (data, response) -> CollectionResponse<Artist> in
                try mapper.map(from: data)
            }
            .flatMap(.latest) { collectionResponse -> SignalProducer<[Artist], Error> in
                let artists = collectionResponse.results
                return .init(value: artists)
            }
    }

}
