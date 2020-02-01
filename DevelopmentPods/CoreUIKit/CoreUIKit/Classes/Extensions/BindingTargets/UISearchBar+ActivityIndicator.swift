//
//  UISearchBar+ActivityIndicator.swift
//  CoreUIKit
//
//  Created by Dre on 01.02.2020.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

extension Reactive where Base: UISearchBar {

    public var isAnimating: BindingTarget<Bool> {
        return makeBindingTarget { searchBar, isAnimating in
            // save default 'search left view' to rightView
            if searchBar.searchTextField.rightView == nil {
                let defaultLeftView = searchBar.searchTextField.leftView
                searchBar.searchTextField.rightView = defaultLeftView
            }

            if isAnimating {
                let activityIndicator = UIActivityIndicatorView.medium
                activityIndicator.startAnimating()
                searchBar.searchTextField.leftView = activityIndicator
            } else {
                searchBar.searchTextField.leftView = searchBar.searchTextField.rightView
                searchBar.searchTextField.rightView = nil
            }
        }
    }

}
