//
//  SearchViewModel.swift
//  MVVMReactiveApp
//
//  Created by Dre on 18.01.2020.
//  Copyright © 2020 Andrey Sidorovnin. All rights reserved.
//

import Foundation
import ReactiveSwift
import CoreKit
import ServiceKit

// MARK: - Protocol
protocol SearchViewModelProtocol {

    // in
    var searchQueryObserver: Signal<String, Never>.Observer { get }
    var artistDidSelect: Signal<Artist, Never>.Observer { get }

    // out
    var searchResults: Property<[Artist]> { get }

    func viewDidLoad()

}

// MARK: - Implementation
final class SearchViewModel: SearchViewModelProtocol {

    // MARK: - Internal Properties
    var searchQueryObserver: Signal<String, Never>.Observer {
        return searchQueryPipe.input
    }

    var artistDidSelect: Signal<Artist, Never>.Observer {
        return artistDidSelectPipe.input
    }

    var searchResults: Property<[Artist]> {
        return Property(searchResultsProperty)
    }

    // MARK: - Private Properties
    private let searchQueryPipe = Signal<String, Never>.pipe()
    private let searchResultsProperty = MutableProperty<[Artist]>([])
    private let artistDidSelectPipe = Signal<Artist, Never>.pipe()

    private let router: SearchRouterProtocol
    private let searchService: SearchServiceProtocol

    // MARK: - Init
    init(router: SearchRouterProtocol, searchService: SearchServiceProtocol) {
        self.router = router
        self.searchService = searchService
    }

    // MARK: - Internal Methods
    func viewDidLoad() {
        searchQueryPipe.output
            .observeValues { [weak self] query in
                self?.searchService
                    .searchArtists(query: query)
                    .startWithResult { [weak self] result in
                        guard let self = self else { return }
                        switch result {
                        case .success(let artists):
                            self.searchResultsProperty.value = artists

                        case .failure(let error):
                            self.router.show(error: error)
                        }
                }
            }

        artistDidSelectPipe.output
            .observeValues { [weak self] artist in
                self?.router.showEvents(forArtist: artist)
            }
    }

}
