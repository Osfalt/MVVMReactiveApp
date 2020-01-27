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

    public var primaryKey: PrimaryKey {
        return (name: "identifier", value: id)
    }

    public init(managedObject: ManagedObject) {
        guard let name = managedObject.name,
            let type = managedObject.type,
            let date = managedObject.date,
            let city = managedObject.city else
        {
            preconditionFailure("All Event's properties must be not nil")
        }

        var artist: Artist?
        if let managedArtist = managedObject.artist {
            artist = Artist(managedObject: managedArtist)
        }

        self.init(id: Int(managedObject.identifier),
                  name: name,
                  type: type,
                  date: date,
                  city: city,
                  popularity: managedObject.popularity,
                  artist: artist)
    }

    public func inverseRelationshipName<T: PersistentConvertible>(forType type: T.Type) -> String? {
        switch String(describing: type) {
        case String(describing: Artist.self):
            return "events"

        default:
            return nil
        }
    }

    public func toManagedObject() -> ManagedObject {
        let eventManagedObject = EventManagedObject.newInDefaultContext()
        eventManagedObject.identifier = Int64(id)
        eventManagedObject.name = name
        eventManagedObject.type = type
        eventManagedObject.date = date
        eventManagedObject.city = city
        eventManagedObject.popularity = popularity
        eventManagedObject.artist = artist?.toManagedObject()

        return eventManagedObject
    }

}
