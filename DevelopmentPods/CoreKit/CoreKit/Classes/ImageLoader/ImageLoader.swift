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
    private let httpClient: HTTPClient
    private let imageResizer: ImageResizerProtocol
    private let imageCache: ImageCacheProtocol?

    // MARK: - Init
    init(httpClient: HTTPClient = DefaultHTTPClient(),
         imageResizer: ImageResizerProtocol = ImageResizer(),
         imageCache: ImageCacheProtocol? = UniversalImageCache())
    {
        self.httpClient = httpClient
        self.imageResizer = imageResizer
        self.imageCache = imageCache
    }

    // MARK: - Internal Methods
    func loadImage(at imageURL: URL) -> SignalProducer<ImageResponse, Error> {
        return loadImage(at: imageURL, size: nil)
    }

    func loadImage(at imageURL: URL, size: CGSize?) -> SignalProducer<ImageResponse, Error> {
        if let cachedImage = imageCache?.cachedImage(forURL: imageURL, size: size) {
            return SignalProducer { (image: cachedImage, isFromCache: true) }
        }

        return httpClient
            .requestData(URLRequest(url: imageURL))
            .map { [weak self] data, _ -> UIImage? in
                guard let self = self else { return nil }
                var loadedImage = UIImage(data: data)

                if let size = size, let image = loadedImage {
                    loadedImage = self.imageResizer.resizedImage(image, for: size)
                }

                return loadedImage
            }
            .on(value: { [weak self] image in
                self?.saveToCacheIfNeeded(image: image, forURL: imageURL)
            })
            .map { (image: $0, isFromCache: false) }
    }

    // MARK: - Private Methods
    private func saveToCacheIfNeeded(image: UIImage?, forURL url: URL) {
        guard let image = image else { return }
        imageCache?.saveToCache(image: image, forURL: url)
    }

}

// MARK: - Factory
public final class ImageLoaderBuilder {

    public static func makeImageLoader() -> ImageLoaderProtocol {
        return ImageLoader()
    }

}
