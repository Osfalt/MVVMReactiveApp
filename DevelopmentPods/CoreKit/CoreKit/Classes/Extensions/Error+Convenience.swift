//
//  Error+Convenience.swift
//  CoreKit
//
//  Created by Dre on 27.01.2020.
//

import Foundation

extension Error {

    public var isNotConnectedToInternet: Bool {
        return (self as NSError).code == URLError.notConnectedToInternet.rawValue
    }

}
