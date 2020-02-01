//
//  PersistentImageCache.swift
//  CoreKit
//
//  Created by Dre on 01.02.2020.
//

import Foundation
import UIKit.UIImage

final class PersistentImageCache: ImageCacheProtocol {

    // MARK: - Constants
    private enum Constant {
        static let imageCacheDirectory = "Images"
        static let imageExtension = "png"
    }

    // MARK: - Private Properties
    private let cacheKeyStrategy: ImageCacheKeyStrategy
    private let fileManager = FileManager.default

    private var imagesCacheDirectoryURL: URL? {
        return fileManager
            .urls(for: .cachesDirectory, in: .userDomainMask)
            .first?
            .appendingPathComponent(Constant.imageCacheDirectory, isDirectory: true)
    }

    // MARK: - Init
    init(cacheKeyStrategy: ImageCacheKeyStrategy = DefaultImageCacheKeyStrategy()) {
        self.cacheKeyStrategy = cacheKeyStrategy
    }

    // MARK: - ImageCacheProtocol
    func cachedImage(forURL imageURL: URL, size: CGSize?) -> UIImage? {
        let cacheKey = cacheKeyStrategy.cacheKey(for: imageURL, size: size)

        guard let imagesCacheDirectoryURL = self.imagesCacheDirectoryURL else {
            return nil
        }
        let cachedImageURL = self.cachedImageURL(forKey: cacheKey, inDirectory: imagesCacheDirectoryURL)

        guard fileManager.fileExists(atPath: cachedImageURL.path) else {
            return nil
        }

        return UIImage(contentsOfFile: cachedImageURL.path)
    }

    func saveToCache(image: UIImage, forURL imageURL: URL) {
        let cacheKey = cacheKeyStrategy.cacheKey(for: imageURL, size: image.size)

        guard let imagesCacheDirectoryURL = self.imagesCacheDirectoryURL else {
            return
        }
        let cachedImageURL = self.cachedImageURL(forKey: cacheKey, inDirectory: imagesCacheDirectoryURL)

        do {
            try fileManager.createDirectory(at: imagesCacheDirectoryURL, withIntermediateDirectories: true)
            try image.pngData()?.write(to: cachedImageURL, options: .atomic)
        } catch {
            print("File error: \(error)")
        }
    }

    // MARK: - Private Methods
    private func cachedImageURL(forKey cacheKey: String, inDirectory directoryURL: URL) -> URL {
        return directoryURL
            .appendingPathComponent(cacheKey, isDirectory: false)
            .appendingPathExtension(Constant.imageExtension)
    }

}
