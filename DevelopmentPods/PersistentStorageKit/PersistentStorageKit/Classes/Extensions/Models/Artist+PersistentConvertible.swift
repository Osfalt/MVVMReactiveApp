//
//  Artist+PersistentConvertible.swift
//  PersistentStorageKit
//
//  Created by Dre on 26.01.2020.
//

import Foundation
import CoreKit
import CoreData

extension Artist: PersistentConvertible {

    public typealias ManagedObject = ArtistManagedObject

    public var primaryKey: PrimaryKey {
        return (name: "identifier", value: id)
    }

    public init(managedObject: ManagedObject) {
        guard let name = managedObject.name else {
            preconditionFailure("Artist name must be not nil")
        }

        let events = managedObject.events?.allObjects as? [Event]
        self.init(id: Int(managedObject.identifier), name: name, events: events)
    }

    public func inverseRelationshipName<T: PersistentConvertible>(forType type: T.Type) -> String? {
        switch String(describing: type) {
        case String(describing: Event.self):
            return "artist"

        default:
            return nil
        }
    }

    public func toManagedObject() -> ManagedObject {
        let artistManagedObject = ArtistManagedObject.newInDefaultContext()
        artistManagedObject.identifier = Int64(id)
        artistManagedObject.name = name

        if let events = events {
            artistManagedObject.events = NSSet(array: events)
        }

        return artistManagedObject
    }

}
