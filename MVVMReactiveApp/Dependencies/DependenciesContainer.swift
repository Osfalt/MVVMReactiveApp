//
//  DependenciesContainer.swift
//  MVVMReactiveApp
//
//  Created by Dre on 20.01.2020.
//  Copyright © 2020 Andrey Sidorovnin. All rights reserved.
//

import Foundation
import CoreKit
import PersistentStorageKit
import ServiceKit

// MARK: - Protocol
protocol DependenciesContainer: AnyObject {

    var searchService: SearchServiceProtocol { get }
    var eventsService: EventsServiceProtocol { get }
    var eventsRepository: EventsRepositoryProtocol { get }
    var storage: PersistentStorage { get }
    var imageLoader: ImageLoaderProtocol { get }

}

// MARK: - Implementation
final class DefaultDependenciesContainer: DependenciesContainer {

    lazy var searchService: SearchServiceProtocol = ServicesFactory.makeSearchService()
    lazy var eventsService: EventsServiceProtocol = ServicesFactory.makeEventsService()
    lazy var eventsRepository: EventsRepositoryProtocol = ServicesFactory.makeEventsRepository(service: eventsService,
                                                                                               storage: storage)
    lazy var storage: PersistentStorage = PersistentStorageFactory.defaultStorage
    lazy var imageLoader: ImageLoaderProtocol = ImageLoaderBuilder.makeImageLoader()

}
