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
            return .init(error: NSError(domain: "err", code: 1, userInfo: nil))
        }
        
        let request = URLRequest(url: url)

        return URLSession.shared.reactive
            .data(with: request)
            .compactMap { (data: Data, response: URLResponse) -> (Data, HTTPURLResponse)? in
                guard let httpResponse = response as? HTTPURLResponse else { return nil }
                return (data, httpResponse)
            }
            .flatMap(.latest) { (data, response) -> SignalProducer<[Artist], Error> in
                guard 200..<300 ~= response.statusCode else {
                    return .init(error: HTTPError.from(code: response.statusCode))
                }
                do {
                    let collectionResponse = try JSONDecoder().decode(CollectionResponse<Artist>.self, from: data)
                    let artists = collectionResponse.resultsPage.results.artist ?? []
                    return .init(value: artists)
                } catch {
                    return .init(error: error)
                }
            }
    }

}

// MARK: - Factory
public final class SearchServiceBuilder {

    public static func makeSearchService() -> SearchServiceProtocol {
        return SearchService()
    }

}
