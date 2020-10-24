//
//  Formatter+Extension.swift
//  Hacker News Example
//
//  Created by Marcio Duarte on 10/23/20.
//

import Foundation

/*
 Unfortunately it still does not work as it seems the Foundation library does not support iso8601 times that include fractional seconds (02:55.000)
 https://stackoverflow.com/questions/46458487/how-to-convert-a-date-string-with-optional-fractional-seconds-using-codable-in-s/46458771#46458771
 */

extension Formatter {
    static let iso8601withFractionalSeconds: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()
}

extension JSONDecoder.DateDecodingStrategy {
    static let iso8601withFractionalSeconds = custom {
        let container = try $0.singleValueContainer()
        let string = try container.decode(String.self)
        
        if let date = Formatter.iso8601withFractionalSeconds.date(from: string) {
            return date
        }
        
        throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid date: \(string)")
    }
}

