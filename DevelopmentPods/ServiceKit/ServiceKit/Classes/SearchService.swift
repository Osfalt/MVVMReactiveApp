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

    init() {
    }

    func searchArtists(query: String) -> SignalProducer<[Artist], Error> {
        guard !query.isEmpty else {
            return .init(value: [])
        }

        guard let url = URLBuilder.searchArtists(query: query).url else {
            // TODO: Make "Invalid URL Error"
            return .init(error: NSError(domain: "err", code: 1, userInfo: nil))
        }
        
        let request = URLRequest(url: url)

        return URLSession.shared.reactive
            .data(with: request)
            .compactMap { (data, response) -> (Data, HTTPURLResponse)? in
                guard let httpResponse = response as? HTTPURLResponse else { return nil }
                return (data, httpResponse)
            }
            .attemptMap { (data, response) -> CollectionResponse<Artist> in
                guard 200..<300 ~= response.statusCode else {
                    throw HTTPError.from(code: response.statusCode)
                }
                return try JSONDecoder().decode(CollectionResponse<Artist>.self, from: data)
            }
            .flatMap(.latest) { collectionResponse -> SignalProducer<[Artist], Error> in
                let artists = collectionResponse.resultsPage.results.artist ?? []
                return .init(value: artists)
            }
    }

}

// MARK: - Factory
public final class SearchServiceBuilder {

    public static func makeSearchService() -> SearchServiceProtocol {
        return SearchService()
    }

}
