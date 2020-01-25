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

    func resizeImage(_ image: UIImage, for size: CGSize) -> UIImage

}

// MARK: - Implementation
final class ImageResizer: ImageResizerProtocol {

    func resizeImage(_ originalImage: UIImage, for size: CGSize) -> UIImage {
        let imageRenderer = UIGraphicsImageRenderer(size: size)
        let resizedImage = imageRenderer.image { _ in
            originalImage.draw(in: CGRect(origin: .zero, size: size))
        }
        return resizedImage
    }

}
