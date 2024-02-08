//
//  PostListView.swift
//  SwiftUIToybox
//
//  Created by Kevin Vu on 2/6/24.
//

import SwiftUI

struct PostListView: View {
    
    @StateObject var viewModel = DIContainer.shared.resolve(PostListViewModel.self)
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.posts) { post in
                    Text(post.title)
                }
            }
        }
        .task {
            await viewModel.fetchPosts()
        }
    }
}

#Preview {
    PostListView()
}
