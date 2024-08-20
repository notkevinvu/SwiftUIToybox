//
//  SwiftUIToyboxApp.swift
//  Toybox
//
//  Created by Kevin Vu on 10/29/23.
//

import SwiftUI

@main
struct SwiftUIToyboxApp: App {
    
    init() {
        DIContainer.shared.injectModules()
    }
    
    var body: some Scene {
        WindowGroup {
            PostListView(viewModel: DIContainer.shared.resolve(PostListViewModel.self))
        }
    }
}
