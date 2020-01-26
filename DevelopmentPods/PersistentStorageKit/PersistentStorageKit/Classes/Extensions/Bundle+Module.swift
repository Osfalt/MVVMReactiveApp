//
//  Bundle+Module.swift
//  PersistentStorageKit
//
//  Created by Dre on 26.01.2020.
//

import Foundation

extension Bundle {

    static var persistentStorageKit: Bundle {
        return Bundle(for: ClassForBundle.self)
    }

    private final class ClassForBundle { }

}
