//
//  Router.swift
//  SwiftUITestingGrounds
//
//  Created by Kevin Vu on 7/9/24.
//

import SwiftUI

@Observable
final class Router {
    
    enum TabDestination {
        case main
        case photoPicker
        case videos
        case map
    }
    
    var selectedTab: TabDestination = .main
    var recentTab: TabDestination = .main
    var videoTabPresented: Bool = false
    
    enum Destination: Hashable, Equatable, CaseIterable {
        case initial
//        case videoView
        case mapView
//        case photoPickerView
        case gridView
        case imageToStringDataTestView
        case tabView
        case thumbnailView
        case carouselView
        case lanConnectionView
        
        var title: String {
            switch self {
                case .initial:
                    "Main view"
//                case .videoView:
//                    "Video view"
                case .mapView:
                    "Map view"
//                case .photoPickerView:
//                    "Photo picker view"
                case .gridView:
                    "Grid view"
                case .imageToStringDataTestView:
                    "Image to String Data view"
                case .tabView:
                    "Tab view"
                case .thumbnailView:
                    "Thumbnail view"
                case .carouselView:
                    "Carousel view"
                case .lanConnectionView:
                    "LAN Connection View"
            }
        }
    }
    
    init(navPath: [Destination] = []) {
        self.navPath = navPath
    }
    
    var navPath: [Destination]
    
    func resetToInitial() {
        navPath = [.initial]
    }
    
    func addDestinationToNavPath(_ destination: Destination) {
        navPath.append(destination)
    }
    
    func popToPreviousDestinationInNavPath() {
        guard navPath.count > 1 else { return }
        navPath.removeLast()
    }
    
    func popToRoot() {
        navPath.removeLast(navPath.count - 1)
    }
    
    @ViewBuilder
    func determineView(for destination: Destination) -> some View {
        switch destination {
            case .initial:
                MainView()
//            case .videoView:
//                RandomView()
            case .mapView:
                TestMapView()
//            case .photoPickerView:
//                PhotoPickerView()
            case .gridView:
                TwoColumnGridView()
            case .imageToStringDataTestView:
                ImageToStringDataTestView()
            case .tabView:
                TestTabView()
            case .thumbnailView:
                ThumbnailView()
            case .carouselView:
//                HorizontalZoomableImageCarouselView()
                PremierImageCarouselHolderView()
            case .lanConnectionView:
                LANConnectionTestView()
        }
    }
}

let testImages: [UIImage] = [
    UIImage(resource: .ez),
    UIImage(resource: .clueless),
    UIImage(resource: .bedge),
    UIImage(resource: .prayge),
    UIImage(resource: .madge),
    UIImage(resource: .monkaw),
    UIImage(resource: .testImage1),
    UIImage(resource: .testImage2),
    UIImage(resource: .testImage3),
    UIImage(resource: .testImage4),
    UIImage(resource: .carinaNebula),
    UIImage(resource: .dogYorkshireTerrier),
    UIImage(resource: .earthObservationFleet20230130),
    UIImage(resource: .reinebringenMountainLofotenIsland),
    UIImage(resource: .tropicalJungleAI),
    UIImage(resource: .yachtFromAbove),
    UIImage(resource: .fiveHead),
    UIImage(resource: .nasaBlackMarbleUSCont),
    UIImage(resource: .nasaBlackMarbleEurope),
    UIImage(resource: .nasaBlackMarbleAsiaEast),
    UIImage(resource: .nasaBlackMarbleAsiaSoutheast)
]

let largeResizedImages: [UIImage] = testImages.compactMap { $0.resizeImage(newWidth: 1000) }

let resizedTestImages: [UIImage] = testImages.compactMap { $0.resizeImage(newWidth: 200) }
