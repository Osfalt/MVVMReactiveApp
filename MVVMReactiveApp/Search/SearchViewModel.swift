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

    // output
    var searchResults: Property<[SearchCellModel]> { get }

    // input
    var searchQuery: Signal<String, Never>.Observer { get }
    var searchResultDidSelect: Signal<IndexPath, Never>.Observer { get }

    func viewDidLoad()

}

// MARK: - Implementation
final class SearchViewModel: SearchViewModelProtocol {

    // MARK: - Internal Properties
    var searchQuery: Signal<String, Never>.Observer {
        return searchQueryPipe.input
    }

    var searchResultDidSelect: Signal<IndexPath, Never>.Observer {
        return artistDidSelectPipe.input
    }

    var searchResults: Property<[SearchCellModel]> {
        return Property(artistsCellModelsProperty)
    }

    // MARK: - Private Properties
    private let searchQueryPipe = Signal<String, Never>.pipe()
    private let searchResultsProperty = MutableProperty<[Artist]>([])
    private let artistsCellModelsProperty = MutableProperty<[SearchCellModel]>([])
    private let artistDidSelectPipe = Signal<IndexPath, Never>.pipe()

    private let router: SearchRouterProtocol
    private let searchService: SearchServiceProtocol

    // MARK: - Init
    init(router: SearchRouterProtocol, searchService: SearchServiceProtocol) {
        self.router = router
        self.searchService = searchService
        setupModelsMapping()
    }

    // MARK: - Internal Methods
    func viewDidLoad() {
        observeSearchQuery()
        observeArtistSelection()
    }

    // MARK: - Private Methods
    private func setupModelsMapping() {
        artistsCellModelsProperty <~ searchResultsProperty
            .map { artists -> [SearchCellModel] in
                return artists.map { SearchCellModel(name: $0.name) }
            }
    }

    private func observeSearchQuery() {
        searchQueryPipe.output
            .observeValues { [weak self] query in
                self?.searchService
                    .searchArtists(query: query)
                    .observe(on: UIScheduler())
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
    }

    private func observeArtistSelection() {
        artistDidSelectPipe.output
            .observeValues { [weak self] indexPath in
                guard let self = self else { return }
                let artist = self.searchResultsProperty.value[indexPath.row]
                self.router.showEvents(forArtist: artist)
            }
    }

}
