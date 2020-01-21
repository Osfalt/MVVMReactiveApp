//
//  SearchRouter.swift
//  MVVMReactiveApp
//
//  Created by Dre on 18.01.2020.
//  Copyright © 2020 Andrey Sidorovnin. All rights reserved.
//

import UIKit
import CoreKit

// MARK: - Protocol
protocol SearchRouterProtocol {

    func showEvents(forArtist artist: Artist)
    func show(error: Error)

}

// MARK: - Implementation
final class SearchRouter: SearchRouterProtocol {

    private weak var viewController: UIViewController?

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    func showEvents(forArtist artist: Artist) {
        let dependencies = EventsModuleDependencies()
        let eventsViewController = EventsModuleBuilder(dependencies: dependencies,
                                                       artist: artist).build()
        viewController?.navigationController?.pushViewController(eventsViewController, animated: true)
    }

    func show(error: Error) {
        let errorAlert = UIAlertController.errorAlert(error)
        viewController?.present(errorAlert, animated: true)
    }

}
