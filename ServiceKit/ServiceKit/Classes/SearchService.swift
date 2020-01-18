//
//  SearchService.swift
//  ServiceKit
//
//  Created by Dre on 18.01.2020.
//

import Foundation

// MARK: - Protocol
public protocol SearchServiceProtocol: AnyObject {
    
}

// MARK: - Implementation
final class SearchService: SearchServiceProtocol {

    init() {

    }

}

// MARK: - Factory
public final class SearchServiceBuilder {

    public static func makeSearchService() -> SearchServiceProtocol {
        return SearchService()
    }

}
