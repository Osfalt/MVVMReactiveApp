//
//  PersistentStorageError.swift
//  PersistentStorageKit
//
//  Created by Dre on 26.01.2020.
//

import Foundation

public enum PersistentStorageError: Error {

    case notNSManagedObject
    case unknown

}

extension PersistentStorageError: LocalizedError {

    public var errorDescription: String? {
        switch self {
        case .notNSManagedObject:
            return "Object's type is not NSManagedObject"

        case .unknown:
            return "Unknown Persistent Storage Error"
        }
    }

}
