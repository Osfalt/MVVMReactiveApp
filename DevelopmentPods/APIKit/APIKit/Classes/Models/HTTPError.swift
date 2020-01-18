//
//  HTTPError.swift
//  APIKit
//
//  Created by Dre on 18.01.2020.
//

import Foundation

public enum HTTPError: Error, Equatable {

    public typealias Message = String

    case unauthorized
    case notFound
    case serverError
    case serviceUnavailable
    case unknown(Message?)

    public static func from(code: Int) -> HTTPError {
        switch code {
        case 401:
            return .unauthorized

        case 404:
            return .notFound

        case 500:
            return .serverError

        case 503:
            return .serviceUnavailable

        default:
            return .unknown(nil)
        }
    }

}

extension HTTPError: LocalizedError {

    public var errorDescription: String? {
        switch self {
        case .unauthorized:
            return "Unauthorized"

        case .notFound:
            return "Resource Not Found"

        case .serverError:
            return "Internal Server Error"

        case .serviceUnavailable:
            return "Service Unavailable"

        case .unknown(let message):
            return message ?? "Unknown Error"
        }
    }

}
