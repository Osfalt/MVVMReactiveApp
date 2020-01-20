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

    // MARK: - Properties
    var window: UIWindow?

    private lazy var dependenciesContainer: DependenciesContainer = DefaultDependenciesContainer()

    // MARK: - Internal Methods
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupRootViewController()
        return true
    }

    // MARK: - Private Methods
    private func setupRootViewController() {
        let dependencies = SearchModuleDependencies(searchService: dependenciesContainer.searchService)
        let searchViewController = SearchModuleBuilder(dependencies: dependencies).build()
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = UINavigationController(rootViewController: searchViewController)
        window.makeKeyAndVisible()
        self.window = window
    }

}
