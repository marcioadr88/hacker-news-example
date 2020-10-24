//
//  AppError.swift
//  Hacker News Example
//
//  Created by Marcio Duarte on 10/22/20.
//

import Foundation

/// Represents an exception on the app
enum AppError: Error {
    /// The provided base url is not valid
    case invalidBaseURL
    
    /// The provided endpoint path is not valid
    case invalidEndpoindURL
    
    /// An network error ocurrs
    case networkError(cause: Error)
    
    /// Cannot parse the Post
    case decodingError(cause: Error)
    
    /// Error querying the DB
    case databaseQueryError(cause: Error)
}

/// Provide an user friendly error message
extension AppError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidBaseURL:
            return NSLocalizedString("The provided base url is not valid", comment: "")
        case .invalidEndpoindURL:
            return NSLocalizedString("The provided endpoint path is not valid", comment: "")
        case .networkError(let cause):
            return cause.localizedDescription
        case .decodingError(let cause):
            return cause.localizedDescription
        case .databaseQueryError(let cause):
            return cause.localizedDescription
        }
    }
}
