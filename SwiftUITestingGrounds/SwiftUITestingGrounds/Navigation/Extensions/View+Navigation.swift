//
//  View+Navigation.swift
//  SwiftUITestingGrounds
//
//  Created by Claude Code on 12/21/24.
//

import SwiftUI

// MARK: - Navigation Destination Helpers

extension View {
    /// Adds a navigation destination handler for a specific `Routable` type.
    ///
    /// Use this to register feature routes with a `NavigationStack`:
    /// ```swift
    /// NavigationStack(path: $router.globalPath) {
    ///     ContentView()
    ///         .routableDestination(for: MediaRoute.self)
    ///         .routableDestination(for: MapRoute.self)
    /// }
    /// ```
    func routableDestination<R: Routable>(for routeType: R.Type) -> some View {
        self.navigationDestination(for: R.self) { route in
            route.body
        }
    }

    /// Adds a navigation destination handler for type-erased `AnyRoute`.
    ///
    /// Use this as a fallback for routes that have been type-erased:
    /// ```swift
    /// NavigationStack(path: $router.globalPath) {
    ///     ContentView()
    ///         .anyRoutableDestination()
    /// }
    /// ```
    func anyRoutableDestination() -> some View {
        self.navigationDestination(for: AnyRoute.self) { route in
            route.body
        }
    }
}

// MARK: - Sheet & FullScreenCover Helpers

extension View {
    /// Presents a sheet for an optional `AnyRoute`.
    ///
    /// Binds to the router's `activeSheet` property:
    /// ```swift
    /// ContentView()
    ///     .sheet(route: $router.activeSheet)
    /// ```
    func sheet(route: Binding<AnyRoute?>) -> some View {
        self.sheet(item: route) { anyRoute in
            anyRoute.body
        }
    }

    /// Presents a full-screen cover for an optional `AnyRoute`.
    ///
    /// Binds to the router's `activeFullScreen` property:
    /// ```swift
    /// ContentView()
    ///     .fullScreenCover(route: $router.activeFullScreen)
    /// ```
    func fullScreenCover(route: Binding<AnyRoute?>) -> some View {
        self.fullScreenCover(item: route) { anyRoute in
            anyRoute.body
        }
    }
}

// MARK: - Router Environment Helpers

extension View {
    /// Convenience modifier to attach both navigation destinations and modal handlers.
    ///
    /// Use this at the root of your navigation stack:
    /// ```swift
    /// NavigationStack(path: $router.globalPath) {
    ///     ContentView()
    /// }
    /// .withAppRouterModals(router: router)
    /// ```
    func withAppRouterModals(router: AppRouter) -> some View {
        @Bindable var router = router
        return self
            .sheet(route: $router.activeSheet)
            .fullScreenCover(route: $router.activeFullScreen)
    }
}
