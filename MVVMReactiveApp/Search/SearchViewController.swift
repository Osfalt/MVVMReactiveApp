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
        static let cellIdentifier = "SearchCell"
    }

    // MARK: - Properties
    private var viewModel: SearchViewModelProtocol!
    private let (lifetime, token) = Lifetime.make()

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var placeholderLabel: UILabel!
    @IBOutlet private weak var bottomConstraint: NSLayoutConstraint!

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
        observeKeyboard()
        viewModel.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if !searchController.searchBar.isFirstResponder {
            searchController.searchBar.becomeFirstResponder()
        }
    }

    // MARK: - Setup ViewModel
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
        viewModel.searchQuery <~ searchController.searchBar.reactive
            .continuousTextValues
            .skipNil()
            .debounce(0.3, on: QueueScheduler.main)

        searchController.searchBar.reactive.isAnimating <~ viewModel.searchResultsAreLoading
        tableView.reactive.reloadData <~ viewModel.searchResults.signal.map(value: ())
        placeholderLabel.reactive.isHidden <~ viewModel.searchResults.signal.map { !$0.isEmpty }
    }

    private func observeKeyboard() {
        NotificationCenter.default.reactive
            .keyboardChange
            .take(during: lifetime)
            .observeValues { [weak self] info in
                guard let self = self else { return }
                let keyboardIsShowing = info.endFrame.origin.y < UIScreen.main.bounds.height
                self.bottomConstraint.constant = keyboardIsShowing ? info.endFrame.height : 0
                UIView.animate(
                    withDuration: info.animationDuration,
                    animations: {
                        UIView.setAnimationCurve(info.animationCurve)
                        self.view.layoutSubviews()
                    }
                )
            }
    }

}

// MARK: - UITableViewDataSource
extension SearchViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.searchResults.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.cellIdentifier, for: indexPath)
        let searchResult = viewModel.searchResults.value[indexPath.row]
        cell.textLabel?.text = searchResult.name
        return cell
    }

}

// MARK: - UITableViewDelegate
extension SearchViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.searchResultDidSelect.send(value: indexPath)
    }

}
