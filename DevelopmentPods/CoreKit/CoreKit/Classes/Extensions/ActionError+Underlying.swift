//
//  ActionError+ Underlying.swift
//  CoreKit
//
//  Created by Dre on 23.01.2020.
//

import Foundation
import ReactiveSwift

extension ActionError {

    public var underlyingError: Swift.Error {
        switch self {
        case .producerFailed(let error):
            return error

        case .disabled:
            return self
        }
    }

}
