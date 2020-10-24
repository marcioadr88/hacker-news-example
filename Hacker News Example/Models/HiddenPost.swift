//
//  HiddenPost.swift
//  Hacker News Example
//
//  Created by Marcio Duarte on 10/23/20.
//

import Foundation
import RealmSwift

/// This class representens a "deleted" from from the user, it is used to filter the posts coming from the service
class HiddenPost: Object {
    @objc dynamic var objectID: String? // we only store the id of the object

    convenience init(post: Post) {
        self.init()
        self.objectID = post.objectID
    }
    
    override class func primaryKey() -> String? {
        return "objectID"
    }
}
