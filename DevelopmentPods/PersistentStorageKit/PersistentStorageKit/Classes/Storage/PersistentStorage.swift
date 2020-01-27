//
//  PersistentStorage.swift
//  CoreKit
//
//  Created by Dre on 26.01.2020.
//

import Foundation

// MARK: - Protocol
public protocol PersistentStorage: AnyObject {

    func configure()

    func object<T: PersistentConvertible>(byPrimaryKey key: StorageKey) -> T?

    func objects<T: PersistentConvertible>(byKey key: StorageKey, sorting: NSSortDescriptor...) -> [T]

    func objects<T: PersistentConvertible>(byKey key: StorageKey,
                                           offset: Int,
                                           limit: Int,
                                           sorting: NSSortDescriptor...) -> [T]

    func allObjects<T: PersistentConvertible>(sorting: NSSortDescriptor...) -> [T]

    func save<T: PersistentConvertible>(object: T)
    func save<T: PersistentConvertible>(objects: [T])

    func delete<T: PersistentConvertible>(object: T)
    func delete<T: PersistentConvertible>(objects: [T])
    func deleteAll<T: PersistentConvertible>(ofType type: T.Type)

    /// Uses only for Core Data storage implementation. Should use instead of saveContext().
    func flush()

}

// MARK: - Factory
public final class PersistentStorageFactory {

    public static var defaultStorage: PersistentStorage {
        return CoreDataStorage.shared
    }

}
