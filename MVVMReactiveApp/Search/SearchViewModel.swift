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

protocol SearchViewModelProtocol {

    func viewDidLoad()

}

final class SearchViewModel: SearchViewModelProtocol {

    // MARK: - Properties
    private let router: SearchRouterProtocol
    private let searchService: SearchServiceProtocol

    // MARK: - Init
    init(router: SearchRouterProtocol, searchService: SearchServiceProtocol) {
        self.router = router
        self.searchService = searchService
    }

    // MARK: - Internal Methods
    func viewDidLoad() {

    }

    // MARK: - Private Methods

}
