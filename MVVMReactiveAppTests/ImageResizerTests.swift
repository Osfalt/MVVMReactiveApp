//
//  ImageResizerTests.swift
//  MVVMReactiveAppTests
//
//  Created by Dre on 26.01.2020.
//  Copyright © 2020 Andrey Sidorovnin. All rights reserved.
//

import XCTest
@testable import CoreKit

final class ImageResizerTests: XCTestCase {

    // MARK: - Private Properties
    private var imageResizer: ImageResizerProtocol!

    // MARK: - Overrides
    override func setUp() {
        imageResizer = ImageResizer()
    }

    // MARK: - Test Cases
    func testResizeToSmallerSize() {
        guard let originalImage = UIImage(named: "test_image", inBundle: .test) else {
            XCTAssertTrue(false, "test_image resource not found")
            return
        }

        let scaleTransform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        let smallerSize = originalImage.size.applying(scaleTransform)
        let resizedImage = imageResizer.resizedImage(originalImage, for: smallerSize)

        XCTAssertEqual(resizedImage.size, smallerSize, "Resized image has wrong size")
    }

    func testResizeToLargerSize() {
        guard let originalImage = UIImage(named: "test_image", inBundle: .test) else {
            XCTAssertTrue(false, "test_image resource not found")
            return
        }

        let scaleTransform = CGAffineTransform(scaleX: 2, y: 2)
        let largerSize = originalImage.size.applying(scaleTransform)
        let resizedImage = imageResizer.resizedImage(originalImage, for: largerSize)

        XCTAssertEqual(resizedImage.size, originalImage.size, "Resized image has wrong size")
        XCTAssertTrue(resizedImage === originalImage, "Resized image is not original image")
    }

}
