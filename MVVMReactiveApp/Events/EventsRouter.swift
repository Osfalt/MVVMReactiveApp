//
//  EventsRouter.swift
//  MVVMReactiveApp
//
//  Created by Dre on 23.01.2020.
//  Copyright © 2020 Andrey Sidorovnin. All rights reserved.
//

import UIKit
import CoreKit

// MARK: - Protocol
protocol EventsRouterProtocol {

    func show(error: Error)

}

// MARK: - Implementation
final class EventsRouter: EventsRouterProtocol {

    private weak var viewController: UIViewController?

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    func show(error: Error) {
        let errorAlert = UIAlertController.errorAlert(error)
        viewController?.present(errorAlert, animated: true)
    }

}
