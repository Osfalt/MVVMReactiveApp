//
//  ArtistManagedObject+CoreDataProperties.swift
//  
//
//  Created by Dre on 26.01.2020.
//
//

import Foundation
import CoreData

extension ArtistManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ArtistManagedObject> {
        return NSFetchRequest<ArtistManagedObject>(entityName: "ArtistManagedObject")
    }

    @NSManaged public var identifier: Int64
    @NSManaged public var name: String?
    @NSManaged public var events: NSSet?

}

// MARK: Generated accessors for events
extension ArtistManagedObject {

    @objc(addEventsObject:)
    @NSManaged public func addToEvents(_ value: EventManagedObject)

    @objc(removeEventsObject:)
    @NSManaged public func removeFromEvents(_ value: EventManagedObject)

    @objc(addEvents:)
    @NSManaged public func addToEvents(_ values: NSSet)

    @objc(removeEvents:)
    @NSManaged public func removeFromEvents(_ values: NSSet)

}
