//
//  DIContainer.swift
//  SwiftUIToybox
//
//  Created by Kevin Vu on 2/6/24.
//

import Foundation
import Swinject
import Domain

/// A singleton class responsible for injecting all dependencies in the app.
final class DIContainer {
    
    static let shared = DIContainer()
    
    private var container = Container()
    
    @MainActor
    func injectModules() {
        
    }
    
    func resolve<T>(_ type: T.Type) -> T {
        container.resolve(T.self)!
    }
}

extension DIContainer {
    private func injectUtils() {
        
    }
}
