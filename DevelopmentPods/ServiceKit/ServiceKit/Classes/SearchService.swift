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

    private let httpClient: HTTPClient

    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }

    func searchArtists(query: String) -> SignalProducer<[Artist], Error> {
        guard !query.isEmpty else {
            return .init(value: [])
        }

        guard let url = URLBuilder.searchArtists(query: query).url else {
            return .init(error: URLError(.badURL))
        }

        let request = URLRequest(url: url)

        return httpClient
            .requestData(request)
            .attemptMap { (data, response) -> CollectionResponse<Artist> in
                return try JSONDecoder().decode(CollectionResponse<Artist>.self, from: data)
            }
            .flatMap(.latest) { collectionResponse -> SignalProducer<[Artist], Error> in
                let artists = collectionResponse.results
                return .init(value: artists)
            }
    }

}
