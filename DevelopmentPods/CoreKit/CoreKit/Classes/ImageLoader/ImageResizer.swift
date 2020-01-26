//
//  ImageResizer.swift
//  CoreKit
//
//  Created by Dre on 25.01.2020.
//

import Foundation
import UIKit.UIImage
import ReactiveSwift

// MARK: - Protocol
public protocol ImageResizerProtocol: AnyObject {

    /// Return resized image. If size param is larger than size of original image, it return original image.
    func resizedImage(_ image: UIImage, for size: CGSize) -> UIImage

}

// MARK: - Implementation
final class ImageResizer: ImageResizerProtocol {

    func resizedImage(_ originalImage: UIImage, for size: CGSize) -> UIImage {
        guard size < originalImage.size else {
            return originalImage
        }

        let imageRenderer = UIGraphicsImageRenderer(size: size)
        let resizedImage = imageRenderer.image { _ in
            originalImage.draw(in: CGRect(origin: .zero, size: size))
        }
        return resizedImage
    }

}
