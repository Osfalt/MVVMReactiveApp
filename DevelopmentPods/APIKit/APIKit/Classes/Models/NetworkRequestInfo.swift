//
//  NetworkRequestInfo.swift
//  APIKit
//
//  Created by Dre on 27.01.2020.
//

import Foundation

// MARK: - Protocol
public protocol NetworkRequestInfo {

    var baseURL: String { get }
    var version: String { get }
    var path: String { get }
    var params: [String: Any] { get }

    var headers: [String: String]? { get }
    var httpMethod: HTTPMethod { get }
    var httpBody: Data? { get }

}

// MARK: - Default Implementation
public extension NetworkRequestInfo {

    var baseURL: String {
        return "https://api.songkick.com/api/"
    }

    var version: String {
        return "3.0"
    }

    var headers: [String: String]? {
        return nil
    }

    var httpBody: Data? {
        return nil
    }

}
