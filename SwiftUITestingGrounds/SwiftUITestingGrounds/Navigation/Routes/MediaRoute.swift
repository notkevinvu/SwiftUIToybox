//
//  MediaRoute.swift
//  SwiftUITestingGrounds
//
//  Created by Claude Code on 12/21/24.
//

import SwiftUI

/// Routes for media-related features (videos, future photo gallery).
///
/// Currently used for sheet-based video player presentation.
/// Extensible for future media navigation flows.
enum MediaRoute: Routable {
    case videoPlayer

    @ViewBuilder
    var body: some View {
        switch self {
        case .videoPlayer:
            RandomView()
        }
    }
}
