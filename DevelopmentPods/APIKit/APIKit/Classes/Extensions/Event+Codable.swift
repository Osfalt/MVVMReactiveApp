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
    }

    // MARK: - Decodable
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(Int.self, forKey: .id)
        let name = try container.decode(String.self, forKey: .name)
        let type = try container.decode(String.self, forKey: .type)

        let startContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .start)

        var date: Date?
        if let dateString = try startContainer.decodeIfPresent(String.self, forKey: .date) {
            date = DateFormatter.apiDateFormatter.date(from: dateString)
        }

        self.init(id: id, name: name, type: type, date: date)
    }

    // MARK: - Encodable
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(type, forKey: .type)

        var startContainer = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .start)
        if let date = date {
            let dateString = DateFormatter.apiDateFormatter.string(from: date)
            try startContainer.encode(dateString, forKey: .date)
        }
    }

}
