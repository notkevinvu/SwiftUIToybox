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
/// All state is `private(set)` to enforce mutation through methods only,
/// preventing arbitrary state corruption from views.
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
@MainActor
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

    /// The currently selected tab. Use `switchTab(to:)` to change.
    private(set) var selectedTab: Tab = .main

    // MARK: - Navigation State

    /// Global navigation path for cross-feature navigation.
    /// Use `navigate(to:)`, `pop()`, and `popToRoot()` to modify.
    private(set) var globalPath = NavigationPath()

    // MARK: - Modal Presentation State

    /// Currently presented sheet route, if any.
    /// Use `presentSheet(_:)` and `dismissSheet()` to modify.
    private(set) var activeSheet: AnyRoute?

    /// Currently presented full-screen cover route, if any.
    /// Use `presentFullScreen(_:)` and `dismissFullScreen()` to modify.
    private(set) var activeFullScreen: AnyRoute?

    // MARK: - Private State

    /// Tracks pending tab-switch navigation to allow cancellation.
    private var pendingSwitchTabTask: Task<Void, Never>?

    // MARK: - Navigation Methods

    /// Navigate to any route by appending it to the global path.
    func navigate<R: Routable>(to route: R) {
        globalPath.append(route.erased)
    }

    /// Pop the most recent route from the global path.
    /// - Returns: `true` if a route was popped, `false` if path was already empty.
    @discardableResult
    func pop() -> Bool {
        guard !globalPath.isEmpty else {
            #if DEBUG
            print("[AppRouter] Warning: Attempted to pop from empty navigation path")
            #endif
            return false
        }
        globalPath.removeLast()
        return true
    }

    /// Pop all routes, returning to the root.
    func popToRoot() {
        globalPath = NavigationPath()
    }

    /// Pop a specific number of routes from the path.
    /// - Returns: The actual number of routes popped (may be less than requested).
    @discardableResult
    func pop(count: Int) -> Int {
        let removeCount = min(count, globalPath.count)
        if removeCount < count {
            #if DEBUG
            print("[AppRouter] Warning: Requested to pop \(count) but only \(removeCount) available")
            #endif
        }
        globalPath.removeLast(removeCount)
        return removeCount
    }

    // MARK: - Sheet Presentation

    /// Present a route as a sheet.
    /// - Note: If a sheet is already presented, it will be replaced.
    func presentSheet<R: Routable>(_ route: R) {
        if activeSheet != nil {
            #if DEBUG
            print("[AppRouter] Warning: Replacing existing sheet with \(route.id)")
            #endif
        }
        activeSheet = route.erased
    }

    /// Dismiss the currently presented sheet.
    func dismissSheet() {
        activeSheet = nil
    }

    // MARK: - Full Screen Cover Presentation

    /// Present a route as a full-screen cover.
    /// - Note: If a full-screen cover is already presented, it will be replaced.
    func presentFullScreen<R: Routable>(_ route: R) {
        if activeFullScreen != nil {
            #if DEBUG
            print("[AppRouter] Warning: Replacing existing full-screen cover with \(route.id)")
            #endif
        }
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
    ///
    /// Navigation is performed after a brief delay (100ms) to ensure
    /// the tab's NavigationStack is mounted before pushing the route.
    ///
    /// - Note: If called multiple times rapidly, only the last navigation
    ///   will be performed (previous pending navigations are cancelled).
    func switchTab<R: Routable>(to tab: Tab, then route: R) {
        // Cancel any pending tab switch navigation
        pendingSwitchTabTask?.cancel()

        selectedTab = tab

        pendingSwitchTabTask = Task {
            do {
                try await Task.sleep(for: .milliseconds(100))
                navigate(to: route)
            } catch is CancellationError {
                #if DEBUG
                print("[AppRouter] Tab switch navigation cancelled - not navigating to \(route.id)")
                #endif
                // Intentionally do not navigate if cancelled
            } catch {
                #if DEBUG
                print("[AppRouter] Unexpected error during tab switch: \(error)")
                #endif
            }
            pendingSwitchTabTask = nil
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

    // MARK: - Bindings for SwiftUI

    /// Binding for the selected tab (for TabView integration).
    var selectedTabBinding: Binding<Tab> {
        Binding(
            get: { self.selectedTab },
            set: { self.selectedTab = $0 }
        )
    }

    /// Binding for the global path (for NavigationStack integration).
    var globalPathBinding: Binding<NavigationPath> {
        Binding(
            get: { self.globalPath },
            set: { self.globalPath = $0 }
        )
    }

    /// Binding for the active sheet (for sheet presentation).
    var activeSheetBinding: Binding<AnyRoute?> {
        Binding(
            get: { self.activeSheet },
            set: { self.activeSheet = $0 }
        )
    }

    /// Binding for the active full-screen cover.
    var activeFullScreenBinding: Binding<AnyRoute?> {
        Binding(
            get: { self.activeFullScreen },
            set: { self.activeFullScreen = $0 }
        )
    }
}
