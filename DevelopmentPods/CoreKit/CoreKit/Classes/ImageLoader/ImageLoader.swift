//
//  ImageLoader.swift
//  CoreKit
//
//  Created by Dre on 25.01.2020.
//

import Foundation
import UIKit.UIImage
import ReactiveSwift

// MARK: - Protocol
public protocol ImageLoaderProtocol: AnyObject {

    typealias ImageResponse = (image: UIImage?, isFromCache: Bool)

    func loadImage(at imageURL: URL) -> SignalProducer<ImageResponse, Error>
    func loadImage(at imageURL: URL, size: CGSize?) -> SignalProducer<ImageResponse, Error>

}

// MARK: - Implementation
final class ImageLoader: ImageLoaderProtocol {

    // MARK: - Private Types
    private typealias CacheKey = NSString

    // MARK: - Private Properties
    private let configuration: Configuration
    private let httpClient: HTTPClient
    private let imageResizer: ImageResizerProtocol
    private let imageCache: NSCache<CacheKey, UIImage>

    // MARK: - Init
    init(configuration: Configuration = .init(cacheType: .inMemory),
         httpClient: HTTPClient = DefaultHTTPClient(),
         imageResizer: ImageResizerProtocol = ImageResizer())
    {
        self.configuration = configuration
        self.httpClient = httpClient
        self.imageResizer = imageResizer

        imageCache = NSCache()
        imageCache.totalCostLimit = configuration.inMemoryCacheTotalSize
    }

    // MARK: - Internal Methods
    func loadImage(at imageURL: URL) -> SignalProducer<ImageResponse, Error> {
        return loadImage(at: imageURL, size: nil)
    }

    func loadImage(at imageURL: URL, size: CGSize?) -> SignalProducer<ImageResponse, Error> {
        let cacheKey = self.cacheKey(for: imageURL, size: size)
        if let cachedImage = imageCache.object(forKey: cacheKey) {
            return SignalProducer { (image: cachedImage, isFromCache: true) }
        }

        return httpClient
            .requestData(URLRequest(url: imageURL))
            .map { [weak self] data, _ -> (UIImage?, Int) in
                guard let self = self else { return (nil, 0) }
                var loadedImage = UIImage(data: data)

                if let size = size, let image = loadedImage {
                    loadedImage = self.imageResizer.resizeImage(image, for: size)
                }

                return (image: loadedImage, sizeInBytes: data.count)
            }
            .on(value: { [weak self] image, sizeInBytes in
                guard let self = self else { return }
                self.saveToInMemoryCacheIfNeeded(image: image,
                                                 forKey: self.cacheKey(for: imageURL, size: size),
                                                 cost: sizeInBytes)
            })
            .map { (image: $0.0, isFromCache: false) }
    }
    

    // MARK: - Private Methods
    private func saveToInMemoryCacheIfNeeded(image: UIImage?, forKey key: NSString, cost: Int) {
        guard let image = image else { return }
        if configuration.cacheType == .inMemory  {
            imageCache.setObject(image, forKey: key, cost: cost)
        }
    }

    private func cacheKey(for url: URL, size: CGSize?) -> NSString {
        var key = url.absoluteString
        if let size = size {
            key.append("-w\(size.width)-h\(size.height))")
        }
        return key as NSString
    }

}

// MARK: - Configuration
extension ImageLoader {

    struct Configuration {

        // MARK: - Internal Types
        enum CacheType {
            case none
            case inMemory
        }

        // MARK: - Private Types
        private enum Constant {
            static let defaultInMemoryCacheTotalCostInBytes = 20 * 1024 * 1024
        }

        // MARK: - Internal Properties
        let cacheType: CacheType
        let inMemoryCacheTotalSize: Int

        // MARK: - Init
        init(cacheType: CacheType, inMemoryCacheTotalSize: Int = Constant.defaultInMemoryCacheTotalCostInBytes) {
            self.cacheType = cacheType
            self.inMemoryCacheTotalSize = inMemoryCacheTotalSize
        }

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

// MARK: - Factory
public final class ImageLoaderBuilder {

    public static func makeImageLoader() -> ImageLoaderProtocol {
        return ImageLoader()
    }

}
