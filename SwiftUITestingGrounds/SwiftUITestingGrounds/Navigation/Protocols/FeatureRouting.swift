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
/// Example:
/// ```swift
/// @Observable
/// final class MediaRouter: FeatureRouting {
///     typealias Route = MediaRoute
///
///     var path: [MediaRoute] = []
///
///     func navigate(to route: MediaRoute) {
///         path.append(route)
///     }
/// }
/// ```
protocol FeatureRouting: AnyObject, Observable {
    associatedtype Route: Routable

    /// The navigation path for this feature's routes.
    var path: [Route] { get set }

    /// Navigate to a specific route by pushing it onto the path.
    func navigate(to route: Route)

    /// Pop the most recent route from the path.
    func pop()

    /// Pop all routes, returning to the root of this feature.
    func popToRoot()
}

// MARK: - Default Implementations

extension FeatureRouting {
    func navigate(to route: Route) {
        path.append(route)
    }

    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
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
