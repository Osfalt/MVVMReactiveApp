//
//  CoreDataStorage.swift
//  PersistentStorageKit
//
//  Created by Dre on 26.01.2020.
//

import Foundation
import CoreData

final class CoreDataStorage: PersistentStorage {

    // MARK: - Constants
    private enum PersistentStore {
        static let name = "MVVMReactiveApp"
    }

    // MARK: Internal Properties
    static let shared = CoreDataStorage()

    var defaultContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    // MARK: - Private Properties
    private lazy var persistentContainer: NSPersistentContainer = {
        guard let modelURL = Bundle.persistentStorageKit.url(forResource: PersistentStore.name, withExtension: "momd") else {
            preconditionFailure("There is no momd file in the bundle")
        }
        guard let model = NSManagedObjectModel(contentsOf: modelURL) else {
            preconditionFailure("Can't load momd file from URL: \(modelURL)")
        }
        let container = NSPersistentContainer(name: PersistentStore.name, managedObjectModel: model)

        container.loadPersistentStores { storeDescription, error in
            guard let error = error as NSError? else { return }
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }

        container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        container.viewContext.automaticallyMergesChangesFromParent = true

        return container
    }()

    // MARK: - PersistentStorage Protocol
    // MARK: Configure
    func configure() {
        _ = persistentContainer
    }

    // MARK: Fetching
    func allObjects<T: PersistentConvertible>(sorting: NSSortDescriptor...) -> [T] {
        let entityName = String(describing: T.ManagedObject.self)
        let fetchRequest = NSFetchRequest<T.ManagedObject>(entityName: entityName)
        fetchRequest.sortDescriptors = sorting

        let managedObjects = try? defaultContext.fetch(fetchRequest)
        let objects = managedObjects?.map(T.init(managedObject:))

        return objects ?? []
    }

    func object<T: PersistentConvertible>(byPrimaryKey key: PrimaryKey) -> T? {
        let entityName = String(describing: T.ManagedObject.self)
        let fetchRequest = NSFetchRequest<T.ManagedObject>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "\(key.name) == %d", key.value)

        let managedObjects = try? defaultContext.fetch(fetchRequest)
        let objects = managedObjects?.map(T.init(managedObject:))

        return objects?.first
    }

    func objects<T, R>(forRelatedObject relatedObject: R, sorting: NSSortDescriptor...) -> [T]
        where T: PersistentConvertible, R: PersistentConvertible
    {
        let entityName = String(describing: T.ManagedObject.self)
        let fetchRequest = NSFetchRequest<T.ManagedObject>(entityName: entityName)
        fetchRequest.sortDescriptors = sorting

        guard let relationshipName = relatedObject.inverseRelationshipName(forType: T.self) else {
            return []
        }

        fetchRequest.predicate = NSPredicate(
            format: "\(relationshipName).\(relatedObject.primaryKey.name) == %d",
            relatedObject.primaryKey.value
        )

        let managedObjects = try? defaultContext.fetch(fetchRequest)
        let objects = managedObjects?.map(T.init(managedObject:))

        return objects ?? []
    }

    // MARK: Saving
    func save<T: PersistentConvertible>(object: T) {
        defaultContext.insert(object.toManagedObject())
    }

    func save<T: PersistentConvertible>(objects: [T]) {
        objects.forEach { defaultContext.insert($0.toManagedObject()) } // todo batch insert
    }

    // MARK: Deleting
    func deleteAll<T: PersistentConvertible>(ofType type: T.Type) {
        let entityName = String(describing: T.ManagedObject.self)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        deleteRequest.resultType = .resultTypeObjectIDs
        let result = try? defaultContext.execute(deleteRequest) as? NSBatchDeleteResult

        if let objectIDArray = result?.result as? [NSManagedObjectID] {
            let changes = [NSDeletedObjectsKey: objectIDArray]
            NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [defaultContext])
        }

        saveContext()
    }

    func delete<T: PersistentConvertible>(objects: [T]) {
        let entityName = String(describing: T.ManagedObject.self)
        let fetchRequest = NSFetchRequest<T.ManagedObject>(entityName: entityName)

        let predicates = objects.map { NSPredicate(format: "\($0.primaryKey.name) == %d", $0.primaryKey.value) }
        fetchRequest.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: predicates)

        let managedObjects = try? defaultContext.fetch(fetchRequest)
        managedObjects?.forEach { defaultContext.delete($0) }

        saveContext()
    }

    func delete<T: PersistentConvertible>(object: T) {
        let entityName = String(describing: T.ManagedObject.self)
        let fetchRequest = NSFetchRequest<T.ManagedObject>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "\(object.primaryKey.name) == %d", object.primaryKey.value)

        let managedObjects = try? defaultContext.fetch(fetchRequest)
        managedObjects?.forEach { defaultContext.delete($0) }

        saveContext()
    }

    // MARK: Flush
    func flush() {
        saveContext()
    }

    // MARK: - Private Methods
    private func saveContext() {
        guard defaultContext.hasChanges else { return }

        do {
            try defaultContext.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }

}
