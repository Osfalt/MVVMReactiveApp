//
//  EventsViewModel.swift
//  MVVMReactiveApp
//
//  Created by Dre on 21.01.2020.
//  Copyright © 2020 Andrey Sidorovnin. All rights reserved.
//

import Foundation
import ReactiveSwift
import CoreKit

// MARK: - Protocol
protocol EventsViewModelProtocol {

    // out
    var artistProperty: Property<Artist> { get }

}

// MARK: - Implementation
final class EventsViewModel: EventsViewModelProtocol {

    let artistProperty: Property<Artist>

    init(artist: Artist) {
        artistProperty = Property(value: artist)
    }

}
