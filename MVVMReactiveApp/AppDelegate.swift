//
//  AppDelegate.swift
//  MVVMReactiveApp
//
//  Created by Dre on 18.01.2020.
//  Copyright © 2020 Andrey Sidorovnin. All rights reserved.
//

import UIKit
import ServiceKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupRootViewController()
        return true
    }

    private func setupRootViewController() {
        let searchVC = SearchViewController.make()
        let router = SearchRouter(viewController: searchVC)
        let searchService = SearchServiceBuilder.makeSearchService()
        let viewModel = SearchViewModel(router: router, searchService: searchService)
        searchVC.setupViewModel(viewModel)

        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = UINavigationController(rootViewController: searchVC)
        window.makeKeyAndVisible()
        self.window = window
    }

}
