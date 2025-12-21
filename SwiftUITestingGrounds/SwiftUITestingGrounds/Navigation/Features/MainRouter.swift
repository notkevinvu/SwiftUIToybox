//
//  MainRouter.swift
//  SwiftUITestingGrounds
//
//  Created by Claude Code on 12/21/24.
//

import SwiftUI

/// Feature router for the Main tab's navigation stack.
///
/// Manages navigation between destinations within the main tab.
/// Uses the `FeatureRouting` protocol's default implementations
/// for `navigate(to:)`, `pop()`, and `popToRoot()`.
///
/// Usage:
/// ```swift
/// @Environment(MainRouter.self) var mainRouter
///
/// Button("Show Grid") {
///     mainRouter.navigate(to: .gridView)
/// }
/// ```
@Observable
@MainActor
final class MainRouter: FeatureRouting {
    var path: [MainRoute] = []
}
