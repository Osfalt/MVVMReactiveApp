//
//  HTTPClient.swift
//  CoreKit
//
//  Created by Dre on 20.01.2020.
//

import Foundation
import ReactiveSwift

// MARK: - Protocol
public protocol HTTPClient {

    func requestData(_ request: URLRequest) -> SignalProducer<(Data, HTTPURLResponse), Error>

}

// MARK: - Implementation
final class DefaultHTTPClient: HTTPClient {

    private let session: URLSession

    init(session: URLSession = .init(configuration: URLSessionConfiguration.default)) {
        self.session = session
    }

    func requestData(_ request: URLRequest) -> SignalProducer<(Data, HTTPURLResponse), Error> {
        return session.reactive
            .data(with: request)
            .compactMap { (data, response) -> (Data, HTTPURLResponse)? in
                guard let httpResponse = response as? HTTPURLResponse else { return nil }
                return (data, httpResponse)
            }
            .attempt { (data, response) in
                guard 200..<300 ~= response.statusCode else {
                    throw HTTPError.from(code: response.statusCode)
                }
            }
    }

}

// MARK: - Factory
public final class HTTPClientBuilder {

    public static func makeHTTPClient() -> HTTPClient {
        return DefaultHTTPClient()
    }

}
