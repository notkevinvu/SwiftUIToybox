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
    /// Use this with **feature-specific routers** that store concrete route types
    /// in typed arrays (`[MediaRoute]`), NOT with `AppRouter.globalPath`.
    ///
    /// Example with a feature router:
    /// ```swift
    /// NavigationStack(path: $mediaRouter.path) {
    ///     MediaHomeView()
    ///         .routableDestination(for: MediaRoute.self)
    /// }
    /// ```
    ///
    /// - Important: For `AppRouter.globalPath` which stores type-erased `AnyRoute`,
    ///   use `anyRoutableDestination()` instead.
    func routableDestination<R: Routable>(for routeType: R.Type) -> some View {
        self.navigationDestination(for: R.self) { route in
            route.body
        }
    }

    /// Adds a navigation destination handler for type-erased `AnyRoute`.
    ///
    /// Use this with `AppRouter.globalPath` which stores type-erased routes:
    /// ```swift
    /// NavigationStack(path: router.globalPathBinding) {
    ///     ContentView()
    ///         .anyRoutableDestination()
    /// }
    /// ```
    ///
    /// This is required because `AppRouter.navigate(to:)` wraps routes in `AnyRoute`,
    /// so the NavigationStack needs to handle `AnyRoute` types.
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
    /// Use with the router's binding properties:
    /// ```swift
    /// ContentView()
    ///     .sheet(route: router.activeSheetBinding)
    /// ```
    func sheet(route: Binding<AnyRoute?>) -> some View {
        self.sheet(item: route) { anyRoute in
            anyRoute.body
        }
    }

    /// Presents a full-screen cover for an optional `AnyRoute`.
    ///
    /// Use with the router's binding properties:
    /// ```swift
    /// ContentView()
    ///     .fullScreenCover(route: router.activeFullScreenBinding)
    /// ```
    func fullScreenCover(route: Binding<AnyRoute?>) -> some View {
        self.fullScreenCover(item: route) { anyRoute in
            anyRoute.body
        }
    }
}

// MARK: - Router Environment Helpers

extension View {
    /// Convenience modifier to attach modal handlers to a view.
    ///
    /// Use this at the root of your navigation stack to enable sheet
    /// and full-screen cover presentations via `AppRouter`:
    /// ```swift
    /// NavigationStack(path: router.globalPathBinding) {
    ///     ContentView()
    ///         .anyRoutableDestination()
    /// }
    /// .withAppRouterModals(router: router)
    /// ```
    ///
    /// This uses the router's binding properties to connect to the
    /// `activeSheet` and `activeFullScreen` state.
    func withAppRouterModals(router: AppRouter) -> some View {
        self
            .sheet(route: router.activeSheetBinding)
            .fullScreenCover(route: router.activeFullScreenBinding)
    }
}
