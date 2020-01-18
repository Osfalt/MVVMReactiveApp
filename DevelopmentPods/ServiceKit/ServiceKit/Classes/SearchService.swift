//
//  SearchService.swift
//  ServiceKit
//
//  Created by Dre on 18.01.2020.
//

import Foundation
import ReactiveSwift

// MARK: - Protocol
public protocol SearchServiceProtocol: AnyObject {

    func searchArtists(query: String) -> SignalProducer<String, Error>
    
}

// MARK: - Implementation
final class SearchService: SearchServiceProtocol {

    init() {

    }

    func searchArtists(query: String) -> SignalProducer<String, Error> {
        return .empty
    }

}

// MARK: - Factory
public final class SearchServiceBuilder {

    public static func makeSearchService() -> SearchServiceProtocol {
        return SearchService()
    }

}
