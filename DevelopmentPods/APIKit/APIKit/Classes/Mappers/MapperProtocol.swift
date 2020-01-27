//
//  MapperProtocol.swift
//  APIKit
//
//  Created by Dre on 27.01.2020.
//

import Foundation

public protocol MapperProtocol {

    associatedtype Model

    func map(from data: Data) throws -> Model

}
