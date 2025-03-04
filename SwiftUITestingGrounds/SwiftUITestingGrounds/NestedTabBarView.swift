//
//  NestedTabBarView.swift
//  SwiftUITestingGrounds
//
//  Created by Kevin Vu on 3/4/25.
//

import SwiftUI

struct NestedTabBarView: View {
    @State private var topLevelTabSelection: TopLevelTab = .home
    @State private var nestedTabSelection: NestedTab = .dashboard
    @State private var testArray: [Int] = (0...10).map({$0})
    
    var body: some View {
        NavigationStack {
            topLevelTabView
        }
    }
    
    enum TopLevelTab: Hashable, CaseIterable {
        case home
        case social
        case map
        case settings
        
        var title: String {
            switch self {
                case .home:
                    "Home"
                case .social:
                    "Social"
                case .map:
                    "Map"
                case .settings:
                    "Settings"
            }
        }
        
        var imageTitle: String {
            switch self {
                case .home:
                    "house.fill"
                case .social:
                    "person.2.fill"
                case .map:
                    "map.fill"
                case .settings:
                    "gearshape.fill"
            }
        }
    }
    
    enum NestedTab: Hashable, CaseIterable {
        case dashboard
        case photos
        case videos
        case map
        
        var title: String {
            switch self {
                case .dashboard:
                    "Dashboard"
                case .photos:
                    "Photos"
                case .videos:
                    "Videos"
                case .map:
                    "Map"
            }
        }
        
        var imageTitle: String {
            switch self {
                case .dashboard:
                    "square.grid.3x3.fill"
                case .photos:
                    "photo.fill"
                case .videos:
                    "video.fill"
                case .map:
                    "map.fill"
            }
        }
    }
    
    @ViewBuilder
    private var topLevelTabView: some View {
        TabView(selection: $topLevelTabSelection) {
            ForEach(TopLevelTab.allCases, id: \.self) { topLevelTab in
                Tab(topLevelTab.title, systemImage: topLevelTab.imageTitle, value: topLevelTab) {
                    if topLevelTab == .home {
                        List(testArray, id: \.self) { int in
                            NavigationLink("\(int)") {
                                nestedTabView(int: int)
                            }
                        }
                    } else {
                        Text(topLevelTab.title)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func nestedTabView(int: Int) -> some View {
        TabView(selection: $nestedTabSelection) {
            ForEach(NestedTab.allCases, id: \.self) { nestedTab in
                Tab(nestedTab.title, systemImage: nestedTab.imageTitle, value: nestedTab) {
                    Text(nestedTab.title)
                }
            }
        }
        .navigationTitle("\(int)")
    }
}

#Preview {
    NestedTabBarView()
}
