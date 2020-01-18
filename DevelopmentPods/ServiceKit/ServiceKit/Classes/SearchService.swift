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
        let url = URL(string: "https://api.songkick.com/api/3.0/search/artists.json?apikey=io09K9l3ebJxmxe2&query=\(query)")!
        let request = URLRequest(url: url)
        return URLSession.shared.reactive.data(with: request)
            .flatMap(.latest) { (data, response) -> SignalProducer<[Artist], Error> in
                do {
                    let collectionResponse = try JSONDecoder().decode(CollectionResponse<Artist>.self, from: data)
                    let artists = collectionResponse.resultsPage.results.artist
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
