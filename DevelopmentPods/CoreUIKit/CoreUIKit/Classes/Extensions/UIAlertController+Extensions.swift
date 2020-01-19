//
//  UIAlertController+Extensions.swift
//  CoreUIKit
//
//  Created by Dre on 19.01.2020.
//

import UIKit

extension UIAlertController {

    public static func okAlert(title: String? = nil,
                               message: String?,
                               handler: (() -> Void)? = nil) -> UIAlertController
    {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(
            title: "OK",
            style: .default,
            handler: { _ in
                handler?()
            }
        )
        alert.addAction(okAction)
        return alert
    }

    public static func errorAlert(_ error: Error, handler: (() -> Void)? = nil) -> UIAlertController {
        return okAlert(title: "Error", message: error.localizedDescription, handler: handler)
    }

}
