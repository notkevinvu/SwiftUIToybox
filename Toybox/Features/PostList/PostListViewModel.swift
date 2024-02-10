//
//  PostListViewModel.swift
//  SwiftUIToybox
//
//  Created by Kevin Vu on 2/6/24.
//

import Foundation

final class PostListViewModel: ObservableObject {
    
    let postProvider: PostProvider
    
    init(postProvider: PostProvider) {
        self.postProvider = postProvider
    }
    
    @Published var posts: [Post] = []
    
    @MainActor
    func fetchPosts() async {
        do {
            let posts = try await postProvider.fetchPosts()
            self.posts = posts
        } catch {
            print(error)
        }
    }
}
