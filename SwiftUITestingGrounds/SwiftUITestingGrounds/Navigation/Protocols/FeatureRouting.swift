//
//  FeatureRouting.swift
//  SwiftUITestingGrounds
//
//  Created by Claude Code on 12/21/24.
//

import SwiftUI

/// Protocol for feature-specific routers that manage their own navigation state.
///
/// Each feature module can have its own router conforming to `FeatureRouting`,
/// enabling modular navigation management while maintaining a consistent API.
///
/// Conforming types should be marked with `@Observable` for SwiftUI integration.
///
/// Example:
/// ```swift
/// @Observable
/// final class MediaRouter: FeatureRouting {
///     var path: [MediaRoute] = []
///     // Default implementations from protocol extension handle navigation
/// }
/// ```
protocol FeatureRouting: AnyObject {
    associatedtype Route: Routable

    /// The navigation path for this feature's routes.
    /// Use `navigate(to:)`, `pop()`, and `popToRoot()` to modify.
    var path: [Route] { get set }

    /// Navigate to a specific route by pushing it onto the path.
    func navigate(to route: Route)

    /// Pop the most recent route from the path.
    /// - Returns: `true` if a route was popped, `false` if path was already empty.
    @discardableResult
    func pop() -> Bool

    /// Pop all routes, returning to the root of this feature.
    func popToRoot()
}

// MARK: - Default Implementations

extension FeatureRouting {
    func navigate(to route: Route) {
        path.append(route)
    }

    @discardableResult
    func pop() -> Bool {
        guard !path.isEmpty else {
            #if DEBUG
            print("[FeatureRouting] Warning: Attempted to pop from empty path")
            #endif
            return false
        }
        path.removeLast()
        return true
    }

    func popToRoot() {
        path.removeAll()
    }

    /// Check if the navigation path is empty (at root).
    var isAtRoot: Bool {
        path.isEmpty
    }

    /// The current (topmost) route, if any.
    var currentRoute: Route? {
        path.last
    }
}
