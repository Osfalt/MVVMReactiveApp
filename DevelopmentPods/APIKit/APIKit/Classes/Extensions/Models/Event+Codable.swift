//
//  Event+Codable.swift
//  APIKit
//
//  Created by Dre on 22.01.2020.
//

import Foundation
import CoreKit

extension Event: Codable {

    // MARK: - Coding Keys
    private enum CodingKeys: String, CodingKey {
        case id
        case name = "displayName"
        case type
        case start
        case date
        case popularity
        case location
        case city
    }

    // MARK: - Decodable
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(Int.self, forKey: .id)
        let name = try container.decode(String.self, forKey: .name)
        let type = try container.decode(String.self, forKey: .type)
        let popularity = try container.decode(Double.self, forKey: .popularity)

        // date
        let startContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .start)
        let dateString = try startContainer.decode(String.self, forKey: .date)
        guard let date = DateFormatter.apiDateFormatter.date(from: dateString) else {
            throw DecodingError.dataCorruptedError(forKey: CodingKeys.date,
                                                   in: startContainer,
                                                   debugDescription: "Wrong date format")
        }

        // city
        let locationContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .location)
        let city = try locationContainer.decode(String.self, forKey: .city)

        self.init(id: id, name: name, type: type, date: date, city: city, popularity: popularity)
    }

    // MARK: - Encodable
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(type, forKey: .type)
        try container.encode(popularity, forKey: .popularity)

        // date
        var startContainer = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .start)
        let dateString = DateFormatter.apiDateFormatter.string(from: date)
        try startContainer.encode(dateString, forKey: .date)

        // city
        var locationContainer = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .location)
        try locationContainer.encode(city, forKey: .city)
    }

}
