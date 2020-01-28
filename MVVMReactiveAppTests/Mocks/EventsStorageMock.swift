//
//  EventsStorageMock.swift
//  MVVMReactiveAppTests
//
//  Created by Dre on 28.01.2020.
//  Copyright © 2020 Andrey Sidorovnin. All rights reserved.
//

import Foundation
import CoreKit
import PersistentStorageKit

final class EventsStorageMock: PersistentStorage {

    // MARK: - Private Properties
    private var events: [Event]

    // MARK: - Init
    init(events: [Event]) {
        self.events = events
    }

    // MARK: - Fetching
    func object<T>(byPrimaryKey key: StorageKey) -> T? where T : PersistentConvertible {
        return nil
    }

    func objects<T>(byKey key: StorageKey, sorting: NSSortDescriptor...) -> [T] where T : PersistentConvertible {
        return events as! [T]
    }

    func objects<T>(byKey key: StorageKey, offset: Int, limit: Int, sorting: NSSortDescriptor...) -> [T]
        where T : PersistentConvertible
    {
        return events as! [T]
    }

    func allObjects<T>(sorting: NSSortDescriptor...) -> [T] where T : PersistentConvertible {
        return events as! [T]
    }

    // MARK: - Saving
    func save<T>(object: T) where T : PersistentConvertible {
        events.append(object as! Event)
    }

    func save<T>(objects: [T]) where T : PersistentConvertible {
        events += objects as! [Event]
    }

    // MARK: - Deleting
    func deleteAll<T>(ofType type: T.Type) where T : PersistentConvertible {
        events.removeAll()
    }

    func delete<T>(object: T) where T : PersistentConvertible { }
    func delete<T>(objects: [T]) where T : PersistentConvertible { }

    // MARK: - Counting
    func count<T>(ofType type: T.Type) -> Int where T : PersistentConvertible {
        return events.count
    }

    func count<T>(ofType type: T.Type, byKey key: StorageKey) -> Int where T : PersistentConvertible {
        return events.count
    }

    func configure() { }
    func flush() { }

}
