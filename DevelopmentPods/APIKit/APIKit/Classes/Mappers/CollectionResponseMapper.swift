//
//  CollectionResponseMapper.swift
//  APIKit
//
//  Created by Dre on 27.01.2020.
//

import Foundation

public final class CollectionResponseMapper<T: Decodable>: MapperProtocol {

    public init() {}

    public func map(from data: Data) throws -> CollectionResponse<T> {
        return try JSONDecoder().decode(CollectionResponse<T>.self, from: data)
    }

}
