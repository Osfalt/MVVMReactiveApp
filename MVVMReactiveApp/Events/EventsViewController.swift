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
        artistNameLabel.reactive.text <~ viewModel.artistProperty.map { $0.name }
    }

}

// MARK: - UITableViewDataSource
extension EventsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.cellIdentifier, for: indexPath)
        cell.textLabel?.text = "Event name"
        cell.detailTextLabel?.text = "Event type"
        return cell
    }

}
