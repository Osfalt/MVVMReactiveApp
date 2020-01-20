//
//  URLError+Description.swift
//  CoreKit
//
//  Created by Dre on 20.01.2020.
//

import Foundation

extension URLError {

    public init(_ code: Code) {
        let description: String?
        switch code {
        case .badURL:
            description = "Invalid URL Error"

        default:
            description = nil
        }

        if let description = description {
            self = .init(code, userInfo: [NSLocalizedDescriptionKey: description])
        } else {
            self = .init(code, userInfo: [:])
        }
    }

}
