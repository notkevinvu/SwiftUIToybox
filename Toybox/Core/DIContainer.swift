//
//  DIContainer.swift
//  SwiftUIToybox
//
//  Created by Kevin Vu on 2/6/24.
//

import Foundation
import Swinject

/// A singleton class responsible for injecting all dependencies in the app.
final class DIContainer {
    
    static let shared = DIContainer()
    
    private var container = Container()
    
    @MainActor
    func injectModules() {
        // order doesn't seem to matter here
        // perhaps it only matters when it actually resolves any dependency,
        // then works its way through the graph?
        injectServices()
        injectProviders()
        injectViewModels()
    }
    
    func resolve<T>(_ type: T.Type) -> T {
        container.resolve(T.self)!
    }
}

extension DIContainer {
    
    // MARK: -- Injecting managers
    
    private func injectServices() {
        container.register(NetworkService.self) { _ in
            return RestNetworkServiceAdapter()
        }
    }
    
    // MARK: -- Injecting providers
    
    private func injectProviders() {
        container.register(PostProvider.self) { resolver in
            return PostProviderImpl(networkService: resolver.resolve(NetworkService.self)!)
        }
    }
    
    // MARK: -- Injecting view models
    
    private func injectViewModels() {
        container.register(PostListViewModel.self) { resolver in
            return PostListViewModel(postProvider: resolver.resolve(PostProvider.self)!)
        }
    }
}
