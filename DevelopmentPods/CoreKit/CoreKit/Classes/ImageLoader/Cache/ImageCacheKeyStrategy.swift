//
//  ImageCacheKeyStrategy.swift
//  CoreKit
//
//  Created by Dre on 01.02.2020.
//

import Foundation

// MARK: - Protocol
public protocol ImageCacheKeyStrategy {

    func cacheKey(for url: URL, size: CGSize?) -> String

}

// MARK: - Implementation
final class DefaultImageCacheKeyStrategy: ImageCacheKeyStrategy {

    func cacheKey(for url: URL, size: CGSize?) -> String {
        var cacheKey = url.pathComponents.suffix(3).joined()
        if let size = size {
            cacheKey.append("-w\(Int(size.width))-h\(Int(size.height))")
        }

        guard let regex = try? NSRegularExpression(pattern: "[-_/.]") else {
            preconditionFailure("Can't create NSRegularExpression")
        }

        return regex.stringByReplacingMatches(in: cacheKey,
                                              range: NSRange(location: 0, length: cacheKey.count),
                                              withTemplate: "")
    }

}
