//
//  EventsViewController.swift
//  MVVMReactiveApp
//
//  Created by Dre on 21.01.2020.
//  Copyright © 2020 Andrey Sidorovnin. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift
import CoreUIKit

final class EventsViewController: UIViewController, ViewControllerMaking {

    // MARK: - ViewControllerMaking
    typealias SomeViewController = EventsViewController

    // MARK: - Constants
    private enum Constant {
        static let cellIdentifier = "EventCell"
        static let loadMoreThreshold = 5
    }

    // MARK: - Properties
    private var viewModel: EventsViewModelProtocol!

    @IBOutlet fileprivate weak var tableView: UITableView!
    @IBOutlet private weak var artistNameLabel: UILabel!
    @IBOutlet private weak var artistPhotoImageView: UIImageView!
    @IBOutlet private weak var photoActivityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var eventsActivityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var placeholderLabel: UILabel!
    private lazy var refreshControl = UIRefreshControl()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        bindToViewModel()
        viewModel.viewDidLoad()
    }

    // MARK: - Setup ViewModel
    func setupViewModel(_ viewModel: EventsViewModelProtocol) {
        self.viewModel = viewModel
    }

    // MARK: - Private Methods
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.refreshControl = refreshControl
        tableView.hideEmptyCells()
    }

    private func bindToViewModel() {
        let refreshControlValueChanged = refreshControl.reactive.controlEvents(.valueChanged)
        viewModel.pullToRefreshDidTrigger <~ refreshControlValueChanged.map(value: ())

        artistNameLabel.reactive.text <~ viewModel.artistName
        artistPhotoImageView.reactive.image <~ viewModel.artistPhoto
        photoActivityIndicator.reactive.isAnimating <~ viewModel.artistPhotoIsLoading

        tableView.reactive.reloadData <~ viewModel.events.map(value: ())
        tableView.reactive.isShowLoadMoreFooter <~ viewModel.eventsAreLoadingMore

        refreshControl.reactive.isRefreshing <~ viewModel.eventsAreLoading
                                                .and(refreshControlValueChanged.map(value: true))

        eventsActivityIndicator.reactive.isAnimating <~ viewModel.eventsAreLoading.take(first: 2)
        placeholderLabel.reactive.isHidden <~ viewModel.events.signal.map { !$0.isEmpty }
    }

}

// MARK: - UITableViewDataSource
extension EventsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.events.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.cellIdentifier, for: indexPath)
        let event = viewModel.events.value[indexPath.row]
        cell.textLabel?.text = event.name
        cell.detailTextLabel?.text = event.details
        return cell
    }

}

// MARK: - UITableViewDelegate
extension EventsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard indexPath.row >= viewModel.events.value.count - Constant.loadMoreThreshold - 1 else {
            return
        }
        viewModel.loadMoreDidTrigger.send(value: ())
    }

}
