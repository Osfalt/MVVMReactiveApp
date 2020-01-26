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

    public init(object: ManagedObject) {
        guard let name = object.name,
            let type = object.type,
            let date = object.date,
            let city = object.city else
        {
            preconditionFailure("All Event's properties must be not nil")
        }

        self.init(id: Int(object.identifier),
                  name: name,
                  type: type,
                  date: date,
                  city: city,
                  popularity: object.popularity)
    }

    public func toManagedObject() -> ManagedObject {
        let eventManagedObject = EventManagedObject.newInDefaultContext()
        eventManagedObject.identifier = Int64(id)
        eventManagedObject.name = name
        eventManagedObject.type = type
        eventManagedObject.date = date
        eventManagedObject.city = city
        eventManagedObject.popularity = popularity
        return eventManagedObject
    }

}
