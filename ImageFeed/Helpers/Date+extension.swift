//
//  Date extension.swift
//  ImageFeed
//
//  Created by Vitaly Anpilov on 02.02.2023.
//

import Foundation

extension Date {
    
    private static let iso8601Formatter = ISO8601DateFormatter()
    
    static private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ru_ru")
        return formatter
    }()
    
    var dateTimeString: String { Date.dateFormatter.string(from: self) }
    
    static func convertStringToDate(_ string: String) -> Date? {
        return iso8601Formatter.date(from: string)
    }
}
