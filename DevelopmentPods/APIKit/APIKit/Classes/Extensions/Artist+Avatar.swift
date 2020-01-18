//
//  Artist+Avatar.swift
//  APIKit
//
//  Created by Dre on 18.01.2020.
//

import Foundation
import CoreKit

extension Artist {

    public func avatarURL(size: APIResource.Size) -> URL {
        return APIResource.avatar.url(forID: id, size: size)
    }

}
