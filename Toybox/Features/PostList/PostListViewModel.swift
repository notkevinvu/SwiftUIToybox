//
//  PostListViewModel.swift
//  SwiftUIToybox
//
//  Created by Kevin Vu on 2/6/24.
//

import Foundation

final class PostListViewModel: ObservableObject {
    
    // not sure if we want to keep this as a property here for the view
    // to use or if we want to only allow the view to access these items
    // through the success view state
//    @Published private(set) var posts: [Post] = []
    @Published private(set) var state: ViewState = .initial
    let postProvider: PostProvider
    
    init(postProvider: PostProvider) {
        self.postProvider = postProvider
    }
    
    enum ViewState {
        case initial
        case loading
        case empty
        case success(posts: [Post])
        case error(_ error: String)
    }
    
    @MainActor
    func fetchPosts() async {
        state = .loading
        do {
            // delay task to show off loading animation
            try await Task.sleep(for: .seconds(1))
            let posts = try await postProvider.fetchPosts()
            state = .success(posts: posts)
        } catch {
            state = .error(error.localizedDescription)
        }
    }
}
