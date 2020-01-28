//
//  EventsRepositoryTests.swift
//  MVVMReactiveAppTests
//
//  Created by Dre on 28.01.2020.
//  Copyright © 2020 Andrey Sidorovnin. All rights reserved.
//

import XCTest
import ReactiveSwift
import CoreKit
import APIKit
import PersistentStorageKit
@testable import ServiceKit

final class EventsRepositoryTests: XCTestCase {

    // MARK: - Constants
    private enum EventID {
        static let remote = 1
        static let cached = 2
    }

    // MARK: - Private Properties
    private var eventsRepository: EventsRepositoryProtocol!

    // MARK: - Test Cases
    func testPastEventsSavingToStorage() {
        // setup
        let remoteEvents: [Event] = .init(repeating: Event(id: EventID.remote), count: 5)

        let eventsService: EventsServiceProtocol = EventsServiceMock(events: remoteEvents)
        let storage: PersistentStorage = EventsStorageMock(events: [])

        eventsRepository = EventsRepository(eventsService: eventsService, storage: storage)

        // action
        eventsRepository.pastEvents(forArtistID: 0, ascending: false, page: 0, perPage: 0)
            .start()

        // check
        let savedEvents: [Event] = storage.allObjects()
        XCTAssertEqual(remoteEvents.count, savedEvents.count, "Saved events count must be equal to remote")
    }

    func testPastEventsFetching_OkInternet() {
        // setup
        let remoteEvents: [Event] = .init(repeating: .init(id: EventID.remote), count: 5)
        let cachedEvents: [Event] = .init(repeating: .init(id: EventID.cached), count: 5)

        let eventsService: EventsServiceProtocol = EventsServiceMock(events: remoteEvents)
        let storage: PersistentStorage = EventsStorageMock(events: cachedEvents)

        eventsRepository = EventsRepository(eventsService: eventsService, storage: storage)

        // action
        guard let pastEventsResult = fetchPastEventsFromRepository(service: eventsService, storage: storage) else {
            XCTAssertTrue(false, "Can't obtain past events result from repository")
            return
        }

        // check
        switch pastEventsResult {
        case .success(let events, let isFromCache):
            XCTAssertEqual(events, remoteEvents)
            XCTAssertFalse(isFromCache)

        case .failure:
            XCTAssertTrue(false)
        }
    }

    func testPastEventsFetching_NoInternet_NotEmptyStorage() {
        // setup
        let remoteEvents: [Event] = .init(repeating: .init(id: EventID.remote), count: 5)
        let cachedEvents: [Event] = .init(repeating: .init(id: EventID.cached), count: 10)

        let eventsService: EventsServiceProtocol = EventsServiceMock(events: remoteEvents,
                                                                     error: URLError.noInternet)
        let storage: PersistentStorage = EventsStorageMock(events: cachedEvents)

        eventsRepository = EventsRepository(eventsService: eventsService, storage: storage)

        // action
        guard let pastEventsResult = fetchPastEventsFromRepository(service: eventsService, storage: storage) else {
            XCTAssertTrue(false, "Can't obtain past events result from repository")
            return
        }

        // check
        switch pastEventsResult {
        case .success(let events, let isFromCache):
            XCTAssertEqual(events, cachedEvents)
            XCTAssertTrue(isFromCache)

        case .failure:
            XCTAssertTrue(false)
        }
    }

    func testPastEventsFetching_NoInternet_EmptyStorage() {
        // setup
        let eventsService: EventsServiceProtocol = EventsServiceMock(events: [], error: URLError.noInternet)
        let storage: PersistentStorage = EventsStorageMock(events: [])

        eventsRepository = EventsRepository(eventsService: eventsService, storage: storage)

        // action
        guard let pastEventsResult = fetchPastEventsFromRepository(service: eventsService, storage: storage) else {
            XCTAssertTrue(false, "Can't obtain past events result from repository")
            return
        }

        // check
        switch pastEventsResult {
        case .success:
            XCTAssertTrue(false)

        case .failure(let error):
            XCTAssertTrue(error is URLError)
            XCTAssertEqual((error as NSError).code, URLError.notConnectedToInternet.rawValue)
        }
    }

    func testPastEventsFetching_AnyOtherError_NotEmptyStorage() {
        // setup
        let cachedEvents: [Event] = .init(repeating: .init(id: EventID.cached), count: 10)

        let eventsService: EventsServiceProtocol = EventsServiceMock(events: [], error: URLError(.unknown))
        let storage: PersistentStorage = EventsStorageMock(events: cachedEvents)

        eventsRepository = EventsRepository(eventsService: eventsService, storage: storage)

        // action
        guard let pastEventsResult = fetchPastEventsFromRepository(service: eventsService, storage: storage) else {
            XCTAssertTrue(false, "Can't obtain past events result from repository")
            return
        }

        // check
        switch pastEventsResult {
        case .success:
            XCTAssertTrue(false)

        case .failure(let error):
            XCTAssertTrue(error is URLError)
            XCTAssertEqual((error as NSError).code, URLError.unknown.rawValue)
        }
    }

    func testPastEventsFetching_AnyOtherError_EmptyStorage() {
        // setup
        let eventsService: EventsServiceProtocol = EventsServiceMock(events: [], error: URLError(.unknown))
        let storage: PersistentStorage = EventsStorageMock(events: [])

        eventsRepository = EventsRepository(eventsService: eventsService, storage: storage)

        // action
        guard let pastEventsResult = fetchPastEventsFromRepository(service: eventsService, storage: storage) else {
            XCTAssertTrue(false, "Can't obtain past events result from repository")
            return
        }

        // check
        switch pastEventsResult {
        case .success:
            XCTAssertTrue(false)

        case .failure(let error):
            XCTAssertTrue(error is URLError)
            XCTAssertEqual((error as NSError).code, URLError.unknown.rawValue)
        }
    }

    // MARK: - Private Methods
    private func fetchPastEventsFromRepository(
        service: EventsServiceProtocol,
        storage: PersistentStorage) -> Result<(events: [Event], isFromCache: Bool), Error>?
    {
        eventsRepository = EventsRepository(eventsService: service, storage: storage)

        return eventsRepository
            .pastEvents(forArtistID: 0, ascending: false, page: 0, perPage: 0)
            .single()
    }

}

// MARK: - Private Extensions
private extension Event {

    init(id: Int) {
        self.init(id: id, name: "", type: "", date: Date(), city: "", popularity: 0)
    }

}

private extension URLError {

    static var noInternet: URLError {
        return URLError(.notConnectedToInternet)
    }

}
