//
//  AppTabView.swift
//  SwiftUITestingGrounds
//
//  Created by Claude Code on 12/21/24.
//

import SwiftUI

/// Root tab container for the application.
///
/// Replaces the legacy `TestTabView` with the modular navigation system.
/// Each tab displays its corresponding feature view, with the Videos tab
/// presenting a sheet instead of navigating.
///
/// Tab structure:
/// - **Main**: Navigation list with various test destinations
/// - **Photos**: Photo picker functionality
/// - **Videos**: Presents video player as a sheet (intercepts tab selection)
/// - **Map**: Map view with search functionality
struct AppTabView: View {
    @Environment(AppRouter.self) private var appRouter
    @Environment(MainRouter.self) private var mainRouter
    @Environment(ImageCarouselViewModel.self) private var imageCarouselVm
    @EnvironmentObject private var randomVm: RandomViewModel

    var body: some View {
        TabView(selection: appRouter.selectedTabBinding) {
            // MARK: - Main Tab
            MainTabContent()
                .tabItem {
                    Label(AppRouter.Tab.main.title, systemImage: AppRouter.Tab.main.icon)
                }
                .tag(AppRouter.Tab.main)

            // MARK: - Photos Tab
            PhotoPickerView()
                .tabItem {
                    Label(AppRouter.Tab.photoPicker.title, systemImage: AppRouter.Tab.photoPicker.icon)
                }
                .tag(AppRouter.Tab.photoPicker)

            // MARK: - Videos Tab (placeholder - actual content shown as sheet)
            Color.clear
                .tabItem {
                    Label(AppRouter.Tab.videos.title, systemImage: AppRouter.Tab.videos.icon)
                }
                .tag(AppRouter.Tab.videos)

            // MARK: - Map Tab
            TestMapView()
                .tabItem {
                    Label(AppRouter.Tab.map.title, systemImage: AppRouter.Tab.map.icon)
                }
                .tag(AppRouter.Tab.map)
        }
        .onChange(of: appRouter.selectedTab) { oldValue, newValue in
            handleTabChange(from: oldValue, to: newValue)
        }
        .withAppRouterModals(router: appRouter)
    }

    /// Handles special tab behaviors (e.g., Videos tab presents a sheet).
    private func handleTabChange(from oldTab: AppRouter.Tab, to newTab: AppRouter.Tab) {
        switch newTab {
        case .videos:
            // Guard against re-entry: only handle if coming from a different tab
            guard oldTab != .videos else { return }
            // Revert to previous tab and present video player as sheet
            appRouter.switchTab(to: oldTab)
            appRouter.presentSheet(MediaRoute.videoPlayer)
        default:
            break
        }
    }
}

// MARK: - Main Tab Content

/// Content view for the Main tab with NavigationStack.
///
/// Extracted to keep hero animation overlay at the correct scope
/// (spanning both source grid and destination detail views).
private struct MainTabContent: View {
    @Environment(MainRouter.self) private var mainRouter
    @Environment(ImageCarouselViewModel.self) private var imageCarouselVm

    var body: some View {
        @Bindable var mainRouter = mainRouter

        NavigationStack(path: $mainRouter.path) {
            MainView()
                .routableDestination(for: MainRoute.self)
        }
        // Hero animation overlay - must be at NavigationStack level
        // to span source (grid) and destination (detail) views
        .overlay {
            if imageCarouselVm.selectedItem != nil {
                ImageDetailCarouselView()
                    .allowsHitTesting(imageCarouselVm.showDetailView)
            }
        }
        .overlayPreferenceValue(HeroKey.self) { value in
            if let selectedItem = imageCarouselVm.selectedItem,
               let sAnchor = value[selectedItem.id + "SOURCE"],
               let dAnchor = value[selectedItem.id + "DEST"]
            {
                HeroLayer(
                    item: selectedItem,
                    sAnchor: sAnchor,
                    dAnchor: dAnchor
                )
            }
        }
    }
}

#Preview {
    AppTabView()
        .environment(AppRouter())
        .environment(MainRouter())
        .environment(MapViewModel())
        .environment(ImageCarouselViewModel())
        .environmentObject(RandomViewModel())
}
