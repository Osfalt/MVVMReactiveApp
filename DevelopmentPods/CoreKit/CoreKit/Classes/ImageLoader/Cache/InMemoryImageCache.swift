//
//  InMemoryImageCache.swift
//  CoreKit
//
//  Created by Dre on 01.02.2020.
//

import Foundation
import UIKit.UIImage

final class InMemoryImageCache: ImageCacheProtocol {

    // MARK: - Constants
    private enum Constant {
        static let defaultCacheTotalCostInBytes = 20 * 1024 * 1024
    }

    // MARK: - Private Properties
    private let imageCache: NSCache<NSString, UIImage>
    private let cacheKeyStrategy: ImageCacheKeyStrategy

    // MARK: - Init
    init(cacheTotalSizeInBytes: Int = Constant.defaultCacheTotalCostInBytes,
         cacheKeyStrategy: ImageCacheKeyStrategy = DefaultImageCacheKeyStrategy())
    {
        imageCache = NSCache()
        imageCache.totalCostLimit = cacheTotalSizeInBytes
        self.cacheKeyStrategy = cacheKeyStrategy
    }

    // MARK: - ImageCacheProtocol
    func cachedImage(forURL imageURL: URL, size: CGSize?) -> UIImage? {
        let cacheKey = cacheKeyStrategy.cacheKey(for: imageURL, size: size)
        return imageCache.object(forKey: cacheKey as NSString)
    }

    func saveToCache(image: UIImage, forURL imageURL: URL) {
        let cacheKey = cacheKeyStrategy.cacheKey(for: imageURL, size: image.size)
        let cost = image.pngData()?.count ?? 0
        imageCache.setObject(image, forKey: cacheKey as NSString, cost: cost)
    }

}

// MARK: - Helper Extensions
// it prevents eviction of image from memory in background mode
extension UIImage: NSDiscardableContent {

    public func beginContentAccess() -> Bool {
        return true
    }

    public func endContentAccess() { }

    public func discardContentIfPossible() { }

    public func isContentDiscarded() -> Bool {
        return false
    }

}
