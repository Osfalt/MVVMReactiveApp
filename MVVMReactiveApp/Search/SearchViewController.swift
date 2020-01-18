//
//  SearchViewController.swift
//  MVVMReactiveApp
//
//  Created by Dre on 18.01.2020.
//  Copyright © 2020 Andrey Sidorovnin. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift
import CoreUIKit

final class SearchViewController: UIViewController {

    // MARK: - Properties
    private var viewModel: SearchViewModelProtocol!

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var placeholderLabel: UILabel!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    private lazy var footerLoadMoreView = LoadMoreView()

    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.autocapitalizationType = .none
        searchController.dimsBackgroundDuringPresentation = false
//        definesPresentationContext = true
        return searchController
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupSearchController()
        bindToViewModel()

        viewModel.viewDidLoad()
    }

    // MARK: - Setup
    func setupViewModel(_ viewModel: SearchViewModelProtocol) {
        self.viewModel = viewModel
    }

    // MARK: - Private Methods
    private func setupSearchController() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }

    private func bindToViewModel() {
        viewModel.searchObserver <~ searchController.searchBar.reactive.continuousTextValues.skipNil()
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
