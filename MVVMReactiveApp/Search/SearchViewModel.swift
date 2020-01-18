//
//  SearchViewModel.swift
//  MVVMReactiveApp
//
//  Created by Dre on 18.01.2020.
//  Copyright © 2020 Andrey Sidorovnin. All rights reserved.
//

import Foundation
import ReactiveSwift
import ServiceKit

// MARK: - Protocol
protocol SearchViewModelProtocol {

    // in
    var searchObserver: Signal<String, Never>.Observer { get }

    // out

    func viewDidLoad()

}

// MARK: - Implementation
final class SearchViewModel: SearchViewModelProtocol {

    // MARK: - Properties
    var searchObserver: Signal<String, Never>.Observer {
        return searchPipe.input
    }

    private let searchPipe = Signal<String, Never>.pipe()

    private let router: SearchRouterProtocol
    private let searchService: SearchServiceProtocol

    // MARK: - Init
    init(router: SearchRouterProtocol, searchService: SearchServiceProtocol) {
        self.router = router
        self.searchService = searchService
    }

    // MARK: - Internal Methods
    func viewDidLoad() {
        searchPipe.output.observeValues { [weak self] query in
            print("query = \(query)")
            guard let self = self else { return }
            let searchResult = self.searchService.searchArtists(query: query)
            searchResult.startWithResult { result in
                switch result {
                case .success(let artists):
                    print("success = \(artists.count)")

                case .failure(let error):
                    print("error = \(error)")
                }
            }
        }
    }

    // MARK: - Private Methods

}
