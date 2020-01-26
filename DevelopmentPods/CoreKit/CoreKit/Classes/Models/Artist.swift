//
//  Artist.swift
//  CoreKit
//
//  Created by Dre on 18.01.2020.
//

import Foundation

public struct Artist {

    public let id: Int
    public let name: String

    public var events: [Event]?

    public init(id: Int, name: String, events: [Event]? = nil) {
        self.id = id
        self.name = name
        self.events = events
    }

}

extension Artist: Equatable {

    public static func == (lhs: Artist, rhs: Artist) -> Bool {
        return lhs.id == rhs.id
    }

}
