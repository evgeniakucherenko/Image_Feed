//
//  DateFormatterProvider.swift
//  Image_Feed
//
//  Created by Evgenia Kucherenko on 29.07.2024.
//

import Foundation
import UIKit

final class DateFormatterProvider {
    static let shared = DateFormatterProvider()
    
    private init() {}
    
    let iso8601DateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        return formatter
    }()
    
    let displayDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM yyyy"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
}
