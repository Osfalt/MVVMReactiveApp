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
    }

    // MARK: - Properties
    private var viewModel: EventsViewModelProtocol!

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var artistNameLabel: UILabel!
    @IBOutlet private weak var artistImageView: UIImageView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    private lazy var footerLoadMoreView = LoadMoreView()

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
        tableView.hideEmptyCells()
    }

    private func bindToViewModel() {
        artistNameLabel.reactive.text <~ viewModel.artist.map { $0.name }
        tableView.reactive.reloadData <~ viewModel.events.map(value: ())
        activityIndicator.reactive.isAnimating <~ viewModel.eventsAreLoading
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
        cell.detailTextLabel?.text = event.type
        return cell
    }

}
