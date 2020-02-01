//
//  ImageCacheProtocol.swift
//  CoreKit
//
//  Created by Dre on 01.02.2020.
//

import Foundation
import UIKit.UIImage

public protocol ImageCacheProtocol: AnyObject {

    func cachedImage(forURL imageURL: URL, size: CGSize?) -> UIImage?
    func saveToCache(image: UIImage, forURL imageURL: URL)

}
