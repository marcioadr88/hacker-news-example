//
//  Post.swift
//  Hacker News Example
//
//  Created by Marcio Duarte on 10/22/20.
//

import Foundation
import RealmSwift

/// Represents an Hacker News post
class Post: Object, Codable {
    @objc dynamic var objectID: String?
    @objc dynamic var storyTitle: String?
    @objc dynamic var title: String?
    @objc dynamic var author: String?
    @objc dynamic var url: String?
    @objc dynamic var createdAt: Date?

    override class func primaryKey() -> String? {
        return "objectID"
    }
    
    private enum CodingKeys: String, CodingKey {
        case title, author, objectID, url
        case storyTitle = "story_title"
        case createdAt = "created_at"
    }
}
