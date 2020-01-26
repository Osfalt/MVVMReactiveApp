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
        static let containerName = "MVVMReactiveApp"
    }

    private enum EntityName {
        static let movie = "Movie"
        static let genre = "Genre"
    }

    // MARK: - Private Properties
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: PersistentStore.containerName)

        container.persistentStoreDescriptions.forEach { $0.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey) }
        container.loadPersistentStores { storeDescription, error in
            guard let error = error as NSError? else { return }
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }

        container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        container.viewContext.automaticallyMergesChangesFromParent = true

        do {
            try container.viewContext.setQueryGenerationFrom(.current)
        } catch {
            fatalError("Failed to pin viewContext to the current generation:\(error)")
        }

        return container
    }()

    private var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    // MARK: - PersistentStorage Protocol
    func configure() {
        _ = persistentContainer
    }

    // MARK: Fetching
    func objects<T: PersistentConvertible>() -> [T] {
        return []
    }

    // MARK: Saving
    func save<T: PersistentConvertible>(object: T) throws {

    }

    func flush() {
        saveContext()
    }

    // MARK: - Private Methods
    private func saveContext() {
        guard context.hasChanges else { return }

        do {
            try context.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }

}
