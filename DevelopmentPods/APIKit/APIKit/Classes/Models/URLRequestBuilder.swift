//
//  URLRequestBuilder.swift
//  APIKit
//
//  Created by Dre on 18.01.2020.
//

import Foundation

// MARK: - Protocol
public protocol URLRequestBuilderProtocol {

    func request(with info: NetworkRequestInfo) -> URLRequest

}

// MARK: - Implementation
public final class DefaultURLRequestBuilder: URLRequestBuilderProtocol {

    // MARK: - Constants
    private enum Constant {
        static var apiKey = "io09K9l3ebJxmxe2"
    }

    public init() { }

    public func request(with info: NetworkRequestInfo) -> URLRequest {
        guard let url = urlComponents(info: info).url else {
            preconditionFailure("Invalid URL")
        }

        var request = URLRequest(url: url)
        request.httpMethod = info.httpMethod.rawValue

        if info.httpMethod == .post {
            request.httpBody = info.httpBody
        }

        return request
    }

    private func urlComponents(info: NetworkRequestInfo) -> URLComponents {
        let urlString = info.baseURL + info.version + info.path
        guard var components = URLComponents(string: urlString) else {
            preconditionFailure("Invalid URL")
        }

        var queryItems = [URLQueryItem(name: "apikey", value: Constant.apiKey)]
        if info.httpMethod == .get {
            queryItems += info.params.map { URLQueryItem.init(name: $0.key, value: String(describing: $0.value)) }
        }
        components.queryItems = queryItems

        return components
    }

}
