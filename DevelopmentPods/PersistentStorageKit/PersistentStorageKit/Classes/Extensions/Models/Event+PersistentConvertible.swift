//
//  Event+PersistentConvertible.swift
//  PersistentStorageKit
//
//  Created by Dre on 26.01.2020.
//

import Foundation
import CoreKit
import CoreData

extension Event: PersistentConvertible {

    public typealias ManagedObject = EventManagedObject

    public enum Field {
        public static let id = "identifier"
        public static let name = "name"
        public static let city = "city"
        public static let date = "date"
        public static let popularity = "popularity"
        public static let type = "type"
        public static let artistID = "artistIdentifier"
    }

    public var primaryKey: StorageKey {
        return .init(name: Field.id, value: id)
    }

    public init(managedObject: ManagedObject) {
        guard let name = managedObject.name,
            let type = managedObject.type,
            let date = managedObject.date,
            let city = managedObject.city else
        {
            preconditionFailure("All Event's properties must be not nil")
        }

        self.init(id: Int(managedObject.identifier),
                  name: name,
                  type: type,
                  date: date,
                  city: city,
                  popularity: managedObject.popularity,
                  artistID: managedObject.artistIdentifier?.intValue)
    }

    public func toManagedObject() -> ManagedObject {
        let eventManagedObject = EventManagedObject.newInPrivateContext()
        eventManagedObject.identifier = Int64(id)
        eventManagedObject.name = name
        eventManagedObject.type = type
        eventManagedObject.date = date
        eventManagedObject.city = city
        eventManagedObject.popularity = popularity
        eventManagedObject.artistIdentifier = artistID.map { NSNumber(value: $0) }

        return eventManagedObject
    }

}
