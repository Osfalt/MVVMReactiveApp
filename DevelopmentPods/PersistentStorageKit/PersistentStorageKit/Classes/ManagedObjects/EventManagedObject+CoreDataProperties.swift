//
//  EventManagedObject+CoreDataProperties.swift
//  
//
//  Created by Dre on 27.01.2020.
//
//

import Foundation
import CoreData

extension EventManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EventManagedObject> {
        return NSFetchRequest<EventManagedObject>(entityName: "EventManagedObject")
    }

    @NSManaged public var city: String?
    @NSManaged public var date: Date?
    @NSManaged public var identifier: Int64
    @NSManaged public var name: String?
    @NSManaged public var popularity: Double
    @NSManaged public var type: String?
    @NSManaged public var artistIdentifier: NSNumber?
    @NSManaged public var artist: NSManagedObject?

}
