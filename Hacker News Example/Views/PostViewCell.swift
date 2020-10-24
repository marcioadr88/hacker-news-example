//
//  PostViewCell.swift
//  Hacker News Example
//
//  Created by Marcio Duarte on 10/23/20.
//

import Foundation
import UIKit

/// Each cell of the table view
class PostViewCell: UITableViewCell {
    /// Post title
    @IBOutlet weak var titleLabel: UILabel!
    
    /// Post author
    @IBOutlet weak var authorLabel: UILabel!
    
    /// Post created at timestamp
    @IBOutlet weak var timestampLabel: UILabel!
    
    /// The post corresponding to this cell
    var post: Post? {
        didSet {
            titleLabel.text = post?.title ?? post?.storyTitle
            authorLabel.text = post?.author
            
            if let createdAt = post?.createdAt {
                timestampLabel.text = DateUtils.getRelativeTime(for: createdAt)
            } else {
                timestampLabel.text = ""
            }
        }
    }
}
