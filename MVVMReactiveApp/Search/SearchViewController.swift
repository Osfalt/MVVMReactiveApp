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

final class SearchViewController: UIViewController, ViewControllerMaking {

    // MARK: - ViewControllerMaking
    typealias SomeViewController = SearchViewController

    // MARK: - Constants
    private enum Constant {
        static let cellIdentifier = "ArtistCell"
    }

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
        return searchController
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupSearchController()
        setupTableView()
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

    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.hideEmptyCells()
    }

    private func bindToViewModel() {
        viewModel.searchQueryObserver <~ searchController.searchBar.reactive
            .continuousTextValues
            .skipNil()
            .debounce(0.3, on: QueueScheduler.main)

        tableView.reactive.reloadData <~ viewModel.searchResults.signal.map(value: ())
        placeholderLabel.reactive.isHidden <~ viewModel.searchResults.signal.map { !$0.isEmpty }
    }

}

// MARK: - UITableViewDataSource
extension SearchViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.searchResults.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.cellIdentifier, for: indexPath)
        cell.textLabel?.text = viewModel.searchResults.value[indexPath.row].name
        return cell
    }

}

// MARK: - UITableViewDelegate
extension SearchViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
