//
//  MainRoute.swift
//  SwiftUITestingGrounds
//
//  Created by Claude Code on 12/21/24.
//

import SwiftUI

/// Routes available within the Main tab's navigation stack.
///
/// Each case corresponds to a destination that can be pushed onto
/// the MainRouter's navigation path.
enum MainRoute: Routable, CaseIterable {
    case gridView
    case imageToStringData
    case thumbnailView
    case carouselView
    case lanConnection

    var title: String {
        switch self {
        case .gridView:
            "Grid View"
        case .imageToStringData:
            "Image to String Data"
        case .thumbnailView:
            "Thumbnail View"
        case .carouselView:
            "Carousel View"
        case .lanConnection:
            "LAN Connection"
        }
    }

    @ViewBuilder
    var body: some View {
        switch self {
        case .gridView:
            TwoColumnGridView()
                .navigationTitle(title)
        case .imageToStringData:
            ImageToStringDataTestView()
                .navigationTitle(title)
        case .thumbnailView:
            ThumbnailView()
                .navigationTitle(title)
        case .carouselView:
            PremierImageCarouselHolderView()
                .navigationTitle(title)
        case .lanConnection:
            LANConnectionTestView()
                .navigationTitle(title)
        }
    }
}
