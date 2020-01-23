//
//  CollectionResponse.swift
//  APIKit
//
//  Created by Dre on 18.01.2020.
//

import Foundation
import CoreKit

public struct CollectionResponse<Element: Decodable> {

    public let results: [Element]
    public let totalEntries: Int
    public let perPage: Int
    public let page: Int
    public let status: String

}

extension CollectionResponse: Decodable {

    // MARK: - Coding Keys
    private enum CodingKeys: String, CodingKey {
        case resultsPage

        case results
        case totalEntries
        case perPage
        case page
        case status

        case artist
        case event
    }

    // MARK: - Decodable
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let resultsPageContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .resultsPage)
        let resultsContainer = try resultsPageContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .results)

        var results: [Element] = []
        if Element.self == Artist.self {
            let artists = try resultsContainer.decodeIfPresent([Artist].self, forKey: .artist) ?? []
            results = artists as! [Element]
        } else if Element.self == Event.self {
            let events = try resultsContainer.decodeIfPresent([Event].self, forKey: .event) ?? []
            results = events as! [Element]
        }

        let totalEntries = try resultsPageContainer.decode(Int.self, forKey: .totalEntries)
        let perPage = try resultsPageContainer.decode(Int.self, forKey: .perPage)
        let page = try resultsPageContainer.decode(Int.self, forKey: .page)
        let status = try resultsPageContainer.decode(String.self, forKey: .status)

        self.init(results: results,
                  totalEntries: totalEntries,
                  perPage: perPage,
                  page: page,
                  status: status)
    }

}
