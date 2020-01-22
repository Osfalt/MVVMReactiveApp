//
//  EventsModuleBuilder.swift
//  MVVMReactiveApp
//
//  Created by Dre on 21.01.2020.
//  Copyright © 2020 Andrey Sidorovnin. All rights reserved.
//

import UIKit
import CoreKit
import ServiceKit

// MARK: - Dependencies
final class EventsModuleDependencies {

    let eventsService: EventsServiceProtocol

    init(eventsService: EventsServiceProtocol) {
        self.eventsService = eventsService
    }

}

// MARK: - Builder
final class EventsModuleBuilder {

    private let dependencies: EventsModuleDependencies
    private let artist: Artist

    init(dependencies: EventsModuleDependencies, artist: Artist) {
        self.dependencies = dependencies
        self.artist = artist
    }

    func build() -> UIViewController {
        let viewController = EventsViewController.make()
        let router = EventsRouter(viewController: viewController)
        let eventsService = dependencies.eventsService
        let viewModel = EventsViewModel(router: router, eventsService: eventsService, artist: artist)
        viewController.setupViewModel(viewModel)
        return viewController
    }

}
