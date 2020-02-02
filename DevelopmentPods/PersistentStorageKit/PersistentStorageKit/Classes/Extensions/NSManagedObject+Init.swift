//
//  NSManagedObject+Init.swift
//  PersistentStorageKit
//
//  Created by Dre on 26.01.2020.
//

import CoreData

extension NSManagedObject {

    static func newInPrivateContext() -> Self {
        let context = CoreDataStorage.shared.privateContext
        let entityName = String(describing: self)
        guard let entity = NSEntityDescription.entity(forEntityName: entityName, in: context) else {
            preconditionFailure("Can't initialize entity with name \(entityName) in context \(context)")
        }
        return Self(entity: entity, insertInto: nil)
    }

}
