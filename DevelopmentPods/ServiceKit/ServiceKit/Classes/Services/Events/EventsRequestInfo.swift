//
//  EventsRequestInfo.swift
//  ServiceKit
//
//  Created by Dre on 27.01.2020.
//

import Foundation
import APIKit

enum EventsRequestInfo: NetworkRequestInfo {

    case past(artistID: Int, ascending: Bool, page: Int, perPage: Int)
    case upcoming(artistID: Int, page: Int, perPage: Int)

    var path: String {
        switch self {
        case .past(let artistID, _, _, _):
            return "/artists/\(artistID)/gigography.json"

        case .upcoming(let artistID, _, _):
            return "/artists/\(artistID)/calendar.json"
        }
    }

    var params: [String: Any] {
        switch self {
        case .past(_, let ascending, let page, let perPage):
            return [
                "order": ascending ? "asc" : "desc",
                "page": page,
                "per_page": perPage
            ]

        case .upcoming(_, let page, let perPage):
            return [
                "page": page,
                "per_page": perPage
            ]
        }
    }

    var httpMethod: HTTPMethod {
        return .get
    }

}
