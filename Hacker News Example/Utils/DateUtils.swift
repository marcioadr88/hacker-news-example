//
//  DateUtils.swift
//  Hacker News Example
//
//  Created by Marcio Duarte on 10/23/20.
//

import Foundation

/// Utility class for handling and formatting `Date`
class DateUtils {
    /// Get the relative time from now eg: 1 hour ago, 2 days ago, etc
    static func getRelativeTime(for date: Date) -> String? {
        let formatter = RelativeDateTimeFormatter()
        formatter.locale = Locale.current // use the current locale
        formatter.unitsStyle = .abbreviated
        
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}
