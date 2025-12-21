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
protocol Routable: Hashable, Identifiable {
    associatedtype Body: View

    /// The view to display for this route.
    @ViewBuilder var body: Body { get }
}

// MARK: - Default Implementation

extension Routable {
    /// Default identifier based on the route's string representation.
    /// Override this for routes with associated values that need stable IDs.
    var id: String {
        String(describing: self)
    }
}
