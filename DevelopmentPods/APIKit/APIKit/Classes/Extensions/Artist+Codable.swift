//
//  Artist+Codable.swift
//  APIKit
//
//  Created by Dre on 18.01.2020.
//

import Foundation
import CoreKit

extension Artist: Codable {

    // MARK: - Coding Keys
    private enum CodingKeys: String, CodingKey {
        case id
        case name = "displayName"
    }

    // MARK: - Decodable
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(Int.self, forKey: .id)
        let name = try container.decode(String.self, forKey: .name)
        self.init(id: id, name: name)
    }

    // MARK: - Encodable
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
    }

}
