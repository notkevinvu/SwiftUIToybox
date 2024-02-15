//
//  PostListView.swift
//  SwiftUIToybox
//
//  Created by Kevin Vu on 2/6/24.
//

import SwiftUI

struct PostListView: View {
    
    @StateObject var viewModel: PostListViewModel
    
    var body: some View {
        NavigationStack {
            containerView
                .navigationTitle("Posts")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Refresh") {
                            Task {
                                await viewModel.fetchPosts()
                            }
                        }
                    }
                }
        }
        .task {
            await viewModel.fetchPosts()
        }
    }
    
    @ViewBuilder
    var containerView: some View {
        switch viewModel.state {
            case .initial:
                // in theory, we would have some base view with
                // skeleton views here that shimmer to replicate some
                // data that hasn't loaded yet
                EmptyView()
                
            case .loading:
                // maybe explore using `.overlay` instead? Might not be
                // compatible with how we use a state enum though
                // Pointfree has an interesting way of doing this
                // for swiftui's state based navigation with enums,
                // but requires their navigation package/library
                ProgressView {
                    Text("Loading posts")
                }
                
            case .empty:
                Text("No posts available!")
                
            case .success(let posts):
                postListView(posts)
                
            case .error(let error):
                Text("Error loading posts - \(error)")
                
        }
    }
    
    @ViewBuilder
    func postListView(_ posts: [Post]) -> some View {
        List {
            ForEach(posts) { post in
                Text(post.title)
            }
        }
        /*
         Refreshable here is a bit buggy due to the `fetchPosts()` method
         updating the view state multiple times - once to set the state to loading
         and another to either set it to success/error. Thus, when we trigger
         `fetchPosts()`, the view gets redrawn almost immediately due to the
         view model's state binding being updated.
         */
//        .refreshable {
//            Task {
//                await viewModel.fetchPosts()
//            }
//        }
    }
}

#Preview {
    PostListView(viewModel: DIContainer.shared.resolve(PostListViewModel.self))
}
