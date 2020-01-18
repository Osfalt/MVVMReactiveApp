//
//  APIResource.swift
//  APIKit
//
//  Created by Dre on 18.01.2020.
//

import Foundation

public enum APIResource {

    public enum Size: String {
        case small = "avatar"
        case large = "large_avatar"
        case huge = "huge_avatar"
    }

    case avatar

    public func url(forID id: Int, size: Size) -> URL {
        let endpoint: String
        switch self {
        case .avatar:
            endpoint = "https://images.sk-static.com/images/media/profile_images/artists"
        }
        return URL(string: "\(endpoint)/\(id)/\(size.rawValue)")!
    }

}
