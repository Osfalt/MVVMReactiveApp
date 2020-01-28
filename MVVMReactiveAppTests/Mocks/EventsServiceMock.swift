//
//  EventsServiceMock.swift
//  MVVMReactiveAppTests
//
//  Created by Dre on 28.01.2020.
//  Copyright © 2020 Andrey Sidorovnin. All rights reserved.
//

import Foundation
import ReactiveSwift
import CoreKit
import ServiceKit

final class EventsServiceMock: EventsServiceProtocol {

    private let events: [Event]
    private let error: Error?

    init(events: [Event], error: Error? = nil) {
        self.events = events
        self.error = error
    }

    func pastEvents(forArtistID artistID: Int, ascending: Bool, page: Int, perPage: Int) -> SignalProducer<[Event], Error> {
        return SignalProducer { () -> Result<[Event], Error> in
            if let error = self.error {
                return .failure(error)
            }
            return .success(self.events)
        }
    }

    func upcomingEvents(forArtistID artistID: Int, page: Int, perPage: Int) -> SignalProducer<[Event], Error> {
        return .empty
    }

}
