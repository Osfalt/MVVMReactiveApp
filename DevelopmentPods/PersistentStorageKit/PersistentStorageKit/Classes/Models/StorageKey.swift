//
//  Keys.swift
//  PersistentStorageKit
//
//  Created by Dre on 27.01.2020.
//

import Foundation

public struct StorageKey {

    public let name: String
    public let value: Int

    public init(name: String, value: Int) {
        self.name = name
        self.value = value
    }

}
