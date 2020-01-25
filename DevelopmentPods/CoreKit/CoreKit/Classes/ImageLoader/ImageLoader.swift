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

    func loadImage(with imageURL: URL) -> SignalProducer<ImageResponse, Error>

}

// MARK: - Implementation
final class ImageLoader: ImageLoaderProtocol {

    // MARK: - Private Types
    private typealias CacheKey = NSString

    // MARK: - Private Properties
    private let configuration: Configuration
    private let imageCache: NSCache<CacheKey, UIImage>
    private let httpClient: HTTPClient

    // MARK: - Init
    init(configuration: Configuration = .init(cacheType: .inMemory),
         httpClient: HTTPClient = DefaultHTTPClient())
    {
        self.configuration = configuration
        self.httpClient = httpClient

        imageCache = NSCache()
        imageCache.totalCostLimit = configuration.inMemoryCacheTotalSize
    }

    // MARK: - Internal Methods
    func loadImage(with imageURL: URL) -> SignalProducer<ImageResponse, Error> {
        if let cachedImage = imageCache.object(forKey: imageURL.absoluteString as NSString) {
            return SignalProducer { (image: cachedImage, isFromCache: true) }
        }

        return httpClient
            .requestData(URLRequest(url: imageURL))
            .map { data, _ in
                (image: UIImage(data: data), size: data.count)
            }
            .on(value: { [weak self] image, size in
                self?.saveToInMemoryCacheIfNeeded(image: image,
                                                  forKey: imageURL.absoluteString,
                                                  cost: size)
            })
            .map { (image: $0.image, isFromCache: false) }
    }

    // MARK: - Private Methods
    private func saveToInMemoryCacheIfNeeded(image: UIImage?, forKey key: String, cost: Int) {
        guard let image = image else { return }
        if configuration.cacheType == .inMemory  {
            imageCache.setObject(image, forKey: key as NSString, cost: cost)
        }
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

// MARK: - Private Extensions
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
