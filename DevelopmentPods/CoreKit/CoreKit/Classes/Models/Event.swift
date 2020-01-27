//
//  Event.swift
//  CoreKit
//
//  Created by Dre on 22.01.2020.
//

import Foundation

public struct Event {

    public let id: Int
    public let name: String
    public let type: String
    public let date: Date
    public let city: String
    public let popularity: Double
    public var artistID: Int?

    public init(id: Int, name: String, type: String, date: Date, city: String, popularity: Double, artistID: Int? = nil) {
        self.id = id
        self.name = name
        self.type = type
        self.date = date
        self.city = city
        self.popularity = popularity
        self.artistID = artistID
    }

}

extension Event: Equatable {

    public static func == (lhs: Event, rhs: Event) -> Bool {
        return lhs.id == rhs.id
    }

}
