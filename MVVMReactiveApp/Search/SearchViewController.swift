//
//  SearchViewController.swift
//  MVVMReactiveApp
//
//  Created by Dre on 18.01.2020.
//  Copyright © 2020 Andrey Sidorovnin. All rights reserved.
//

import UIKit

final class SearchViewController: UIViewController {

    // MARK: - Properties
    private var viewModel: SearchViewModelProtocol!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.viewDidLoad()
    }

    // MARK: - Setup
    func setupViewModel(_ viewModel: SearchViewModelProtocol) {
        self.viewModel = viewModel
    }

}

// MARK: - Factory Method
extension SearchViewController {

    static var identifier: String {
        return "SearchViewController"
    }

    static func make() -> SearchViewController {
        guard let searchVC = UIStoryboard.main.instantiateViewController(withIdentifier: Self.identifier) as? SearchViewController else {
            preconditionFailure("There is no SearchViewController in Main storyboard")
        }
        return searchVC
    }

}

public extension UIStoryboard {

    static var main: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }

}
