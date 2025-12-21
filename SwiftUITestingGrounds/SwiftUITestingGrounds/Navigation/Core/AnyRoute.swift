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
/// Example (manual wrapping):
/// ```swift
/// let mediaRoute = MediaRoute.gallery
/// let anyRoute = AnyRoute(mediaRoute)
/// globalPath.append(anyRoute)
/// ```
///
/// Prefer using the `erased` property for cleaner syntax:
/// ```swift
/// globalPath.append(MediaRoute.gallery.erased)
/// ```
///
/// - Important: Routes should be value types (enums) to avoid retain cycles.
///   If a route has associated values containing reference types, mutations
///   to those references will affect the view but not equality/hashing.
struct AnyRoute: Hashable, Identifiable {
    /// The underlying route's hash value for equality comparison.
    private let base: AnyHashable

    /// Closure that builds the view for this route.
    private let _body: () -> AnyView

    /// The route's identifier.
    let id: String

    #if DEBUG
    /// The original route type name (for debugging).
    let typeName: String
    #endif

    /// Creates a type-erased route from any `Routable` value.
    ///
    /// - Parameter route: The route to wrap. Should be a value type to avoid
    ///   retain cycles in the view-building closure.
    init<R: Routable>(_ route: R) {
        self.base = AnyHashable(route)
        self.id = route.id
        self._body = { AnyView(route.body) }
        #if DEBUG
        self.typeName = String(describing: R.self)
        #endif
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
    ///
    /// This is the preferred way to convert a route for use with `AppRouter`:
    /// ```swift
    /// router.navigate(to: MediaRoute.gallery)
    /// // Internally uses: MediaRoute.gallery.erased
    /// ```
    var erased: AnyRoute {
        AnyRoute(self)
    }
}

// MARK: - Debug Helpers

#if DEBUG
extension AnyRoute: CustomDebugStringConvertible {
    var debugDescription: String {
        "AnyRoute<\(typeName)>(id: \(id))"
    }
}
#endif
