//
//  Bundle+Tests.swift
//  MVVMReactiveAppTests
//
//  Created by Dre on 26.01.2020.
//  Copyright © 2020 Andrey Sidorovnin. All rights reserved.
//

import Foundation

extension Bundle {

    static var test: Bundle {
        return Bundle(for: ClassForBundle.self)
    }

    private final class ClassForBundle { }

}
