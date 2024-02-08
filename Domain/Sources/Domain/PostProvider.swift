//
//  File.swift
//  
//
//  Created by Kevin Vu on 2/6/24.
//

import Foundation
import Data

public protocol PostProvider {
    func fetchPosts() async throws -> [Post]
}

@available(iOS 15.0, *)
public class PostProviderImpl: PostProvider {
    
    let networkService: NetworkService
    
    public init(networkService: NetworkService = RestNetworkServiceAdapter()) {
        self.networkService = networkService
    }
    
    public func fetchPosts() async throws -> [Post] {
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

