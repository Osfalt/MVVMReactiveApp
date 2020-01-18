//
//  CollectionResponse.swift
//  APIKit
//
//  Created by Dre on 18.01.2020.
//

import Foundation

public struct CollectionResponse<Element: Decodable> {

    public let resultsPage: ResultsPage<Element>

}

public struct ResultsPage<Element: Decodable> {

    public struct ArtistResults<Element: Decodable> {
        public let artist: [Element]?
    }

    public let results: ArtistResults<Element>
    public let totalEntries: Int
    public let perPage: Int
    public let page: Int
    public let status: String
    
}

// MARK: - Decodable
extension CollectionResponse: Decodable {}
extension ResultsPage: Decodable {}
extension ResultsPage.ArtistResults: Decodable { }
