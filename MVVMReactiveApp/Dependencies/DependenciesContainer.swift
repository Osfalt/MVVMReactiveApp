//
//  DependenciesContainer.swift
//  MVVMReactiveApp
//
//  Created by Dre on 20.01.2020.
//  Copyright © 2020 Andrey Sidorovnin. All rights reserved.
//

import Foundation
import ServiceKit

// MARK: - Protocol
protocol DependenciesContainer: AnyObject {

    var searchService: SearchServiceProtocol { get }
    var eventsService: EventsServiceProtocol { get }

}

// MARK: - Implementation
final class DefaultDependenciesContainer: DependenciesContainer {

    lazy var searchService: SearchServiceProtocol = ServicesFactory.makeSearchService()
    lazy var eventsService: EventsServiceProtocol = ServicesFactory.makeEventsService()

}
