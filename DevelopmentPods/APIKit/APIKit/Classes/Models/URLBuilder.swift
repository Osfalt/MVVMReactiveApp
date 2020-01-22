//
//  URLBuilder.swift
//  APIKit
//
//  Created by Dre on 18.01.2020.
//

import Foundation

public enum URLBuilder {

    case searchArtists(query: String)
    case upcomingEvents(artistID: Int)

    // MARK: - Constants
    private enum Constant {
        static var apiKey = "io09K9l3ebJxmxe2"
    }

    // MARK: - Public
    public var url: URL? {
        switch self {
        case .searchArtists(let query):
            return searchArtistsURL(query: query)

        case .upcomingEvents(let artistID):
            return upcomingEventsURL(artistID: artistID)
        }
    }

    // MARK: - Private
    private var baseURLComponents: URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.songkick.com"
        components.queryItems = [
            URLQueryItem(name: "apikey", value: Constant.apiKey)
        ]
        return components
    }

    private func path(for endpoint: String) -> String {
        return "/api/3.0\(endpoint)"
    }

    private func searchArtistsURL(query: String) -> URL? {
        var components = baseURLComponents
        components.path = path(for: "/search/artists.json")
        components.queryItems?.append(URLQueryItem(name: "query", value: query))
        return components.url
    }

    private func upcomingEventsURL(artistID: Int) -> URL? {
        var components = baseURLComponents
        components.path = path(for: "/artists/\(artistID)/calendar.json")
        return components.url
    }

}
