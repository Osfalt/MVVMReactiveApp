//
//  SearchModuleBuilder.swift
//  MVVMReactiveApp
//
//  Created by Dre on 20.01.2020.
//  Copyright © 2020 Andrey Sidorovnin. All rights reserved.
//

import UIKit
import ServiceKit

// MARK: - Dependencies
final class SearchModuleDependencies {

    let searchService: SearchServiceProtocol
    let eventsModuleDependencies: EventsModuleDependencies

    init(searchService: SearchServiceProtocol, eventsModuleDependencies: EventsModuleDependencies) {
        self.searchService = searchService
        self.eventsModuleDependencies = eventsModuleDependencies
    }

}

// MARK: - Builder
final class SearchModuleBuilder {

    private let dependencies: SearchModuleDependencies

    init(dependencies: SearchModuleDependencies) {
        self.dependencies = dependencies
    }

    func build() -> UIViewController {
        let viewController = SearchViewController.make()
        let router = SearchRouter(viewController: viewController,
                                  eventsModuleDependencies: dependencies.eventsModuleDependencies)
        let searchService = dependencies.searchService
        let viewModel = SearchViewModel(router: router, searchService: searchService)
        viewController.setupViewModel(viewModel)
        return viewController
    }

}
