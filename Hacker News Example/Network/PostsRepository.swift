//
//  Repository.swift
//  Hacker News Example
//
//  Created by Marcio Duarte on 10/22/20.
//

import Foundation

protocol PostsRepository {
    init(apiClient: APIClient)
    
    func fetchPosts(handler: @escaping ((Result<[Post], AppError>) -> Void))
}

class PostsRepositoryImpl: PostsRepository {
    private let apiClient: APIClient
    
    required init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func fetchPosts(handler: @escaping ((Result<[Post], AppError>) -> Void)) {
        apiClient.fetchPosts { result in
            switch result {
            case .success(let response):
                handler(.success(response.hits))
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
}
