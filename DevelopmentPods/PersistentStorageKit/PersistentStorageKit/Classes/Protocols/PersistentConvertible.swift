//
//  PersistentConvertible.swift
//  PersistentStorageKit
//
//  Created by Dre on 26.01.2020.
//

import Foundation
import CoreData

public typealias PrimaryKey = (name: String, value: Int)

public protocol PersistentConvertible {

    associatedtype ManagedObject: NSManagedObject

    var primaryKey: PrimaryKey { get }

    init(managedObject: ManagedObject)

    func inverseRelationshipName<T: PersistentConvertible>(forType type: T.Type) -> String?

    func toManagedObject() -> ManagedObject

}
