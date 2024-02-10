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
    }
}

#Preview {
    PostListView(viewModel: DIContainer.shared.resolve(PostListViewModel.self))
}
