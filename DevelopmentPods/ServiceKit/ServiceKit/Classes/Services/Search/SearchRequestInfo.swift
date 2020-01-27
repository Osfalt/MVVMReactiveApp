//
//  SearchRequestInfo.swift
//  ServiceKit
//
//  Created by Dre on 27.01.2020.
//

import Foundation
import APIKit

enum SearchRequestInfo: NetworkRequestInfo {

    case artists(query: String)

    var path: String {
        switch self {
        case .artists:
            return "/search/artists.json"
        }
    }

    var params: [String : Any] {
        switch self {
        case .artists(let query):
            return ["query": query]
        }
    }

    var httpMethod: HTTPMethod {
        return .get
    }

}
