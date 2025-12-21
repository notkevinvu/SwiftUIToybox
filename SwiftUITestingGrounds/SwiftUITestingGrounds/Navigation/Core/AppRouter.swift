//
//  AppRouter.swift
//  SwiftUITestingGrounds
//
//  Created by Claude Code on 12/21/24.
//

import SwiftUI

/// Central navigation coordinator that manages global navigation state,
/// tab selection, and modal presentations.
///
/// `AppRouter` serves as the single source of truth for app-wide navigation,
/// while delegating feature-specific routing to child routers.
///
/// Usage:
/// ```swift
/// @Environment(AppRouter.self) var router
///
/// Button("Go to Gallery") {
///     router.navigate(to: MediaRoute.gallery)
/// }
/// ```
@Observable
final class AppRouter {

    // MARK: - Tab Management

    /// Available tabs in the application.
    enum Tab: Hashable, CaseIterable {
        case main
        case media
        case map

        var title: String {
            switch self {
            case .main: "Main"
            case .media: "Media"
            case .map: "Map"
            }
        }

        var icon: String {
            switch self {
            case .main: "house.fill"
            case .media: "photo.stack.fill"
            case .map: "map.fill"
            }
        }
    }

    /// The currently selected tab.
    var selectedTab: Tab = .main

    // MARK: - Navigation State

    /// Global navigation path for cross-feature navigation.
    /// Uses `NavigationPath` for type-erased, heterogeneous route storage.
    var globalPath = NavigationPath()

    // MARK: - Modal Presentation State

    /// Currently presented sheet route, if any.
    var activeSheet: AnyRoute?

    /// Currently presented full-screen cover route, if any.
    var activeFullScreen: AnyRoute?

    // MARK: - Navigation Methods

    /// Navigate to any route by appending it to the global path.
    func navigate<R: Routable>(to route: R) {
        globalPath.append(route.erased)
    }

    /// Pop the most recent route from the global path.
    func pop() {
        guard !globalPath.isEmpty else { return }
        globalPath.removeLast()
    }

    /// Pop all routes, returning to the root.
    func popToRoot() {
        globalPath = NavigationPath()
    }

    /// Pop a specific number of routes from the path.
    func pop(count: Int) {
        let removeCount = min(count, globalPath.count)
        globalPath.removeLast(removeCount)
    }

    // MARK: - Sheet Presentation

    /// Present a route as a sheet.
    func presentSheet<R: Routable>(_ route: R) {
        activeSheet = route.erased
    }

    /// Dismiss the currently presented sheet.
    func dismissSheet() {
        activeSheet = nil
    }

    // MARK: - Full Screen Cover Presentation

    /// Present a route as a full-screen cover.
    func presentFullScreen<R: Routable>(_ route: R) {
        activeFullScreen = route.erased
    }

    /// Dismiss the currently presented full-screen cover.
    func dismissFullScreen() {
        activeFullScreen = nil
    }

    // MARK: - Tab Navigation

    /// Switch to a specific tab.
    func switchTab(to tab: Tab) {
        selectedTab = tab
    }

    /// Switch to a tab and then navigate to a route.
    func switchTab<R: Routable>(to tab: Tab, then route: R) {
        selectedTab = tab
        // Small delay to allow tab switch animation to begin
        Task { @MainActor in
            try? await Task.sleep(for: .milliseconds(100))
            navigate(to: route)
        }
    }

    // MARK: - Computed Properties

    /// Whether the global navigation path is empty.
    var isAtRoot: Bool {
        globalPath.isEmpty
    }

    /// Whether a sheet is currently presented.
    var isShowingSheet: Bool {
        activeSheet != nil
    }

    /// Whether a full-screen cover is currently presented.
    var isShowingFullScreen: Bool {
        activeFullScreen != nil
    }
}
