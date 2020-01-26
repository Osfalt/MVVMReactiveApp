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

    func allObjects<T: PersistentConvertible>() -> [T]
    func object<T: PersistentConvertible>(byPrimaryKey key: PrimaryKey) -> T?
    func objects<T: PersistentConvertible, R: PersistentConvertible>(forRelatedObject relatedObject: R) -> [T]

    func save<T: PersistentConvertible>(objects: [T])
    func save<T: PersistentConvertible>(object: T)

    func delete<T: PersistentConvertible>(objects: [T])
    func delete<T: PersistentConvertible>(object: T)
    func deleteAll<T: PersistentConvertible>(ofType type: T.Type)

    /// Uses only for Core Data. Should use instead of saveContext()
    func flush()

}

// MARK: - Factory
public final class PersistentStorageFactory {

    public static var defaultStorage: PersistentStorage {
        return CoreDataStorage.shared
    }

}
