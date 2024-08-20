//
//  Router.swift
//  SwiftUITestingGrounds
//
//  Created by Kevin Vu on 7/9/24.
//

import SwiftUI

@Observable
final class Router {
    
    enum TabDestination {
        case main
        case photoPicker
        case videos
        case map
    }
    
    var selectedTab: TabDestination = .main
    var recentTab: TabDestination = .main
    var videoTabPresented: Bool = false
    
    enum Destination: Hashable, Equatable, CaseIterable {
        case initial
        case videoView
        case mapView
        case photoPickerView
        case gridView
        case alertTestView
        case tabView
        case thumbnailView
        
        var title: String {
            switch self {
                case .initial:
                    "Main view"
                case .videoView:
                    "Video view"
                case .mapView:
                    "Map view"
                case .photoPickerView:
                    "Photo picker view"
                case .gridView:
                    "Grid view"
                case .alertTestView:
                    "Alert test view"
                case .tabView:
                    "Tab view"
                case .thumbnailView:
                    "Thumbnail view"
            }
        }
    }
    
    init(navPath: [Destination] = []) {
        self.navPath = navPath
    }
    
    var navPath: [Destination]
    
    func resetToInitial() {
        navPath = [.initial]
    }
    
    func addDestinationToNavPath(_ destination: Destination) {
        navPath.append(destination)
    }
    
    func popToPreviousDestinationInNavPath() {
        guard navPath.count > 1 else { return }
        navPath.removeLast()
    }
    
    func popToRoot() {
        navPath.removeLast(navPath.count - 1)
    }
    
    @ViewBuilder
    func determineView(for destination: Destination) -> some View {
        switch destination {
            case .initial:
                MainView()
            case .videoView:
                RandomView()
            case .mapView:
                TestMapView()
            case .photoPickerView:
                PhotoPickerView()
            case .gridView:
                TwoColumnGridView()
            case .alertTestView:
                AlertSheetTestView()
            case .tabView:
                TestTabView()
            case .thumbnailView:
                ThumbnailView()
        }
    }
}
