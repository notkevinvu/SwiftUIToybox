//
//  PostListView.swift
//  SwiftUIToybox
//
//  Created by Kevin Vu on 2/6/24.
//

import SwiftUI

struct PostListView: View {
    
    @StateObject var viewModel = PostListViewModel()
    
    var body: some View {
        NavigationStack {
            Text("Hello, World!")
        }
        .task {
            await viewModel.fetchPosts()
        }
    }
}

#Preview {
    PostListView()
}
