//
//  NewsController.swift
//  Hacker News Example
//
//  Created by Marcio Duarte on 10/23/20.
//

import Foundation
import RealmSwift

/// The NewsController is in charge of fetching the data from internet and storing data locally. It offers an API for refresh data and hide a particular Post.
protocol NewsController {
    var delegate: NewsControllerDelegate? { get set }
    
    func refresh()
    func hidePost(_ post: Post)
}

/// The NewsControllerDelegate expose methods
protocol NewsControllerDelegate {
    /// Called when the Posts is first loaded from local storage
    func initial(results: [Post])
    
    /// Called when the local Posts list change
    func update(results: [Post], deletions: [Int], insertions: [Int], modifications: [Int])
    
    /// Called when an error occurs when reading local stored Posts
    func error(error: AppError)
    
    /// Called when the posts are started fetching from internet
    func beginRefreshing()
    
    /// Called when the posts are finished fetching from internet
    func endRefreshing()
}

class NewsControllerImpl: NewsController {
    var delegate: NewsControllerDelegate?
    
    var postsRepository: PostsRepository
    
    private var notificationToken: NotificationToken? = nil
    
    init(repository: PostsRepository) {
        self.postsRepository = repository
        
        /// load the initial Posts
        queryPosts()
    }
    
    func refresh() {
        delegate?.beginRefreshing()
        
        /// fetch posts from internet
        postsRepository.fetchPosts { [weak self] result in
            self?.delegate?.endRefreshing()
            
            switch result {
            case .success(var posts):
                let realm = try! Realm()
                
                // get hidden posts ids
                let hiddenPostsIds = realm
                    .objects(HiddenPost.self)
                    .asList()
                    .compactMap{ $0.objectID }
                
                // remove the hidden ids from the list
                posts.removeAll { post -> Bool in
                    guard let objectID = post.objectID else {
                        return false
                    }
                    
                    return hiddenPostsIds.contains(objectID)
                }
                
                // save the remaining posts into the DB
                try! realm.write() {
                    realm.add(posts, update: .modified)
                }
                
            case .failure(let error):
                self?.delegate?.error(error: error)
            }
        }
    }
    
    
    private func queryPosts() {
        let realm = try! Realm()
        
        // query all Posts from the DB
        let results = realm
            .objects(Post.self)
            .sorted(by: [
                SortDescriptor(keyPath: "createdAt", ascending: false)
            ])
        
        // observe the local data changes and trigger delegate calls
        notificationToken = results.observe { [weak self] changes in
            switch changes {
            case .initial(let results):
                self?.delegate?.initial(results: results.asList())
                
            case .update(let results, deletions: let deletions, insertions: let insertions, modifications: let modifications):
                self?.delegate?.update(results: results.asList(), deletions: deletions, insertions: insertions, modifications: modifications)
                
            case .error(let error):
                self?.delegate?.error(error: AppError.databaseQueryError(cause: error))
            }
        }
    }
    
    /// hides a particular post
    func hidePost(_ post: Post) {
        let realm = try! Realm()
        // crate the hidden post
        let hiddenPost = HiddenPost(post: post)
        
        try! realm.write {
            // save the hidden post
            realm.add(hiddenPost, update: .modified)
            // and delete the post from the DB
            realm.delete(post)
        }
    }
    
    deinit {
        notificationToken?.invalidate()
    }
}
