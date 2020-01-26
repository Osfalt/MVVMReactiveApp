//
//  PersistentConvertible.swift
//  PersistentStorageKit
//
//  Created by Dre on 26.01.2020.
//

import Foundation
import CoreData

public protocol PersistentConvertible {

    associatedtype ManagedObject: NSManagedObject

    init(object: ManagedObject)

    func toManagedObject() -> ManagedObject

}
