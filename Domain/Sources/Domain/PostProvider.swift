//
//  File.swift
//  
//
//  Created by Kevin Vu on 2/6/24.
//

import Foundation

public protocol PostProvider {
    func fetchPosts()
}

public class PostProviderImpl: PostProvider {
    public init() {}
    
    public func fetchPosts() {
        print("FETCHING POSTS FROM POST PROVIDER")
    }
}
