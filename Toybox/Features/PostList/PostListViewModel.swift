//
//  PostListViewModel.swift
//  SwiftUIToybox
//
//  Created by Kevin Vu on 2/6/24.
//

import Foundation

final class PostListViewModel: ObservableObject {
    
    // MARK: -- View-associated properties
    // not sure if we want to keep this as a property here for the view
    // to use or if we want to only allow the view to access these items
    // through the success view state
    @Published private(set) var posts: [Post] = []
    @Published private(set) var state: ViewState = .initial
    /// Refer to `Binding+Extension.swift` for using this to show alerts/sheets/modals
    @Published var errorMessage: String?
    
    let postProvider: PostProvider
    
    init(postProvider: PostProvider) {
        self.postProvider = postProvider
    }
    
    @MainActor
    func fetchPosts() async {
        // prevent multiple fetch requests from executing unless we can fetch posts
        // i.e. state is .loading
        guard state.canFetchPosts else {
            return
        }
        updateState(.loading)
        
        do {
            // delay task to show off loading animation
            try await Task.sleep(for: .seconds(1))
            let posts = try await postProvider.fetchPosts()
            updateState(.success(posts: posts))
        } catch {
            updateState(.error(error.localizedDescription))
        }
    }
}

// MARK: -- View state

extension PostListViewModel {
    func updateState(_ state: ViewState) {
        self.state = state
        
        switch state {
            case .initial:
                break
            case .loading:
                break
            case .empty:
                break
            case .success(let posts):
                self.posts = posts
            case .error(let error):
                self.errorMessage = error
        }
    }
    
    enum ViewState {
        case initial
        case loading
        case empty
        case success(posts: [Post])
        case error(_ error: String)
        
        var shouldShowError: Bool {
            switch self {
                case .error:
                    return true
                default:
                    return false
            }
        }
        
        var errorMessage: String? {
            switch self {
                case .error(let error):
                    return error
                default:
                    return nil
            }
        }
        
        var canFetchPosts: Bool {
            switch self {
                case .loading:
                    return false
                default:
                    return true
            }
        }
    }
}
