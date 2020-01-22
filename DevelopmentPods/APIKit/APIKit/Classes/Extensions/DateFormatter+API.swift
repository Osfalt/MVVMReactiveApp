//
//  DateFormatter+API.swift
//  APIKit
//
//  Created by Dre on 22.01.2020.
//

import Foundation

extension DateFormatter {

    public static let apiDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }()

}
