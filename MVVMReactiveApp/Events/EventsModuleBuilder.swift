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

    let eventsRepository: EventsRepositoryProtocol
    let imageLoader: ImageLoaderProtocol

    init(eventsRepository: EventsRepositoryProtocol, imageLoader: ImageLoaderProtocol) {
        self.eventsRepository = eventsRepository
        self.imageLoader = imageLoader
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
        let viewModel = EventsViewModel(router: router,
                                        eventsRepository: dependencies.eventsRepository,
                                        imageLoader: dependencies.imageLoader,
                                        artist: artist)
        viewController.setupViewModel(viewModel)
        return viewController
    }

}
