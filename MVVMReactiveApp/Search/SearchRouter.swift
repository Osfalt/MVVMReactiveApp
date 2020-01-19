//
//  SearchRouter.swift
//  MVVMReactiveApp
//
//  Created by Dre on 18.01.2020.
//  Copyright © 2020 Andrey Sidorovnin. All rights reserved.
//

import UIKit

// MARK: - Protocol
protocol SearchRouterProtocol {

    func show(error: Error)

}

// MARK: - Implementation
final class SearchRouter: SearchRouterProtocol {

    private weak var viewController: UIViewController?

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    func show(error: Error) {
        let errorAlert = UIAlertController.errorAlert(error)
        viewController?.present(errorAlert, animated: true)
    }

}
