//
//  UIImage+InBundle.swift
//  MVVMReactiveAppTests
//
//  Created by Dre on 26.01.2020.
//  Copyright © 2020 Andrey Sidorovnin. All rights reserved.
//

import UIKit

extension UIImage {

    convenience init?(named: String, inBundle bundle: Bundle) {
        self.init(named: named, in: bundle, compatibleWith: nil)
    }

}
