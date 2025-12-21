//
//  Routable.swift
//  SwiftUITestingGrounds
//
//  Created by Claude Code on 12/21/24.
//

import SwiftUI

/// Base protocol for all navigable routes in the application.
///
/// Each feature module defines its own route enum conforming to `Routable`,
/// enabling type-safe, decentralized route definitions while maintaining
/// a unified navigation system.
///
/// Routes should typically be enums (value types) to avoid retain cycles
/// when wrapped in `AnyRoute`.
///
/// Example:
/// ```swift
/// enum MediaRoute: Routable {
///     case gallery
///     case detail(item: MediaItem)
///
///     @ViewBuilder
///     var body: some View {
///         switch self {
///         case .gallery:
///             MediaGalleryView()
///         case .detail(let item):
///             MediaDetailView(item: item)
///         }
///     }
/// }
/// ```
///
/// - Note: Associated values in route cases must conform to `Hashable`.
protocol Routable: Hashable, Identifiable {
    associatedtype Body: View

    /// The view to display for this route.
    @ViewBuilder var body: Body { get }
}

// MARK: - Default Implementation

extension Routable {
    /// Default identifier based on the route's string representation.
    ///
    /// This produces unique IDs for routes with different associated values,
    /// e.g., `detail(item: Item(id: 1))` and `detail(item: Item(id: 2))`
    /// will have different IDs.
    ///
    /// - Warning: This default may produce unstable identifiers for routes
    ///   with reference-type associated values. Override if you need:
    ///   - Stable IDs across app launches (for state restoration)
    ///   - A simpler ID scheme (e.g., just the case name)
    var id: String {
        String(describing: self)
    }
}
