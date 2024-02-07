//
//  PostListViewModel.swift
//  SwiftUIToybox
//
//  Created by Kevin Vu on 2/6/24.
//

import Foundation
import Domain

final class PostListViewModel: ObservableObject {
    
    let postProvider: PostProvider = PostProviderImpl()
    
    @Published var posts: [Post] = []
    
    func fetchPosts() async {
        postProvider.fetchPosts()
    }
}
