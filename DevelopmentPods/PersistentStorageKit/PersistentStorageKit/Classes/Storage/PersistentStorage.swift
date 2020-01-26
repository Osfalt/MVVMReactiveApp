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

    func objects<T: PersistentConvertible>() -> [T]
//    func object<T: PersistentConvertible>(byPrimaryKey key: AnyHashable) -> T?

//    func save<T: PersistentConvertible>(objects: [T]) throws
    func save<T: PersistentConvertible>(object: T) throws

//    func delete<T: PersistentConvertible>(objects: [T]) throws
//    func delete<T: PersistentConvertible>(object: T) throws
//    func deleteAll<T: PersistentConvertible>(ofType type: T.Type) throws

    /// Uses only for Core Data. Should use instead of saveContext()
    func flush()

}

public protocol PersistentConvertible {

}

// MARK: - Factory
public final class PersistentStorageFactory {

    public static func makeDefaultStorage() -> PersistentStorage {
        return CoreDataStorage()
    }

}
