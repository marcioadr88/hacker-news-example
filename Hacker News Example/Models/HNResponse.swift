//
//  HNResponse.swift
//  Hacker News Example
//
//  Created by Marcio Duarte on 10/22/20.
//

import Foundation

/// The enveloped response from the service
struct HNResponse: Codable {
    var hits: [Post]
    var page: Int
}
