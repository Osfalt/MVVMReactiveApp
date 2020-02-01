//
//  UniversalImageCache.swift
//  CoreKit
//
//  Created by Dre on 01.02.2020.
//

import Foundation
import UIKit.UIImage

final class UniversalImageCache: ImageCacheProtocol {

    // MARK: - Private Properties
    private let inMemoryCache: ImageCacheProtocol
    private let persistentCache: ImageCacheProtocol

    // MARK: - Init
    init(inMemoryCache: ImageCacheProtocol = InMemoryImageCache(),
         persistentCache: ImageCacheProtocol = PersistentImageCache())
    {
        self.inMemoryCache = inMemoryCache
        self.persistentCache = persistentCache
    }

    // MARK: - ImageCacheProtocol
    func cachedImage(forURL imageURL: URL, size: CGSize?) -> UIImage? {
        if let inMemoryCachedImage = inMemoryCache.cachedImage(forURL: imageURL, size: size) {
            return inMemoryCachedImage
        } else if let persistentCachedImage = persistentCache.cachedImage(forURL: imageURL, size: size) {
            return persistentCachedImage
        }
        return nil
    }

    func saveToCache(image: UIImage, forURL imageURL: URL) {
        inMemoryCache.saveToCache(image: image, forURL: imageURL)
        persistentCache.saveToCache(image: image, forURL: imageURL)
    }

}
