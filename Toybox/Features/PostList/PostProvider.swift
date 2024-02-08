//
//  File.swift
//  
//
//  Created by Kevin Vu on 2/6/24.
//

import Foundation

protocol PostProvider {
    func fetchPosts() async throws -> [Post]
}

final class PostProviderImpl: PostProvider {
    
    let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func fetchPosts() async throws -> [Post] {
        // eventually let us pass parameters through function, but for now
        // we can create the request/path entirely here
        let postEndpoint = PostEndpointPath.getPosts
        let posts = try await networkService.request(type: [Post].self, endpoint: postEndpoint)
        return posts
    }
}

enum PostEndpointPath: EndpointPath {
    case getPosts
    
    var method: String {
        return "GET"
    }
    
    var path: String {
        return "/posts"
    }
    
    var parameters: [URLQueryItem] {
        return []
    }
}

