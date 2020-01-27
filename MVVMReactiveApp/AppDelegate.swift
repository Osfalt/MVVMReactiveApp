//
//  AppDelegate.swift
//  MVVMReactiveApp
//
//  Created by Dre on 18.01.2020.
//  Copyright © 2020 Andrey Sidorovnin. All rights reserved.
//

import UIKit
import PersistentStorageKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - Properties
    var window: UIWindow?

    private lazy var dependenciesContainer: DependenciesContainer = DefaultDependenciesContainer()
    private lazy var storage = dependenciesContainer.storage

    // MARK: - Internal Methods
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        storage.configure()
        setupRootViewController()
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        storage.flush()
    }

    // MARK: - Private Methods
    private func setupRootViewController() {
        let eventsModuleDependencies = EventsModuleDependencies(eventsRepository: dependenciesContainer.eventsRepository,
                                                                imageLoader: dependenciesContainer.imageLoader)

        let searchModuleDependencies = SearchModuleDependencies(searchService: dependenciesContainer.searchService,
                                                                eventsModuleDependencies: eventsModuleDependencies)

        let searchViewController = SearchModuleBuilder(dependencies: searchModuleDependencies).build()

        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = UINavigationController(rootViewController: searchViewController)
        window.makeKeyAndVisible()
        self.window = window
    }

}
