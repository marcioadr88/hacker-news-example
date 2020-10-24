//
//  RealmResult+Extension.swift
//  Hacker News Example
//
//  Created by Marcio Duarte on 10/24/20.
//

import Foundation
import RealmSwift

/// Extension to convert Results to an array
extension Results {
    /// Return the result as an array
    func asList() -> [Element] {
        return compactMap {
            $0
        }
    }
}
