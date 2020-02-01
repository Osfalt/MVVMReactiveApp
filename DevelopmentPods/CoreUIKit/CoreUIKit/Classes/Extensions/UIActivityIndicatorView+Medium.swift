//
//  UIActivityIndicatorView+Medium.swift
//  CoreUIKit
//
//  Created by Dre on 01.02.2020.
//

import UIKit

extension UIActivityIndicatorView {

    public static var medium: UIActivityIndicatorView {
        let style: UIActivityIndicatorView.Style
        if #available(iOS 13.0, *) {
            style = .medium
        } else {
            style = .gray
        }
        return UIActivityIndicatorView(style: style)
    }

}
