//
//  TestImages.swift
//  SwiftUITestingGrounds
//
//  Extracted from Router.swift during modular navigation migration.
//

import UIKit

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
