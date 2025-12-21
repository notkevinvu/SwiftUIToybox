//
//  AnyRoute.swift
//  SwiftUITestingGrounds
//
//  Created by Claude Code on 12/21/24.
//

import SwiftUI

/// Type-erased wrapper for any `Routable` type, enabling heterogeneous route storage.
///
/// `NavigationPath` requires `Hashable` types, but we want to store routes from
/// different feature modules in a single path. `AnyRoute` wraps any `Routable`
/// while preserving both hashability and the ability to build views.
///
/// Example:
/// ```swift
/// let mediaRoute = MediaRoute.gallery
/// let anyRoute = AnyRoute(mediaRoute)
/// globalPath.append(anyRoute)
/// ```
struct AnyRoute: Hashable, Identifiable {
    /// The underlying route's hash value for equality comparison.
    private let base: AnyHashable

    /// Closure that builds the view for this route.
    private let _body: () -> AnyView

    /// The route's identifier.
    let id: String

    /// Creates a type-erased route from any `Routable` value.
    init<R: Routable>(_ route: R) {
        self.base = AnyHashable(route)
        self.id = route.id
        self._body = { AnyView(route.body) }
    }

    /// The view to display for this route.
    @ViewBuilder
    var body: some View {
        _body()
    }

    // MARK: - Hashable

    static func == (lhs: AnyRoute, rhs: AnyRoute) -> Bool {
        lhs.base == rhs.base
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(base)
    }
}

// MARK: - Convenience Extensions

extension Routable {
    /// Wraps this route in a type-erased `AnyRoute`.
    var erased: AnyRoute {
        AnyRoute(self)
    }
}
