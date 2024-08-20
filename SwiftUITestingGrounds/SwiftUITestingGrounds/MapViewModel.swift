//
//  MapViewModel.swift
//  SwiftUITestingGrounds
//
//  Created by Kevin Vu on 5/16/24.
//

import Foundation
import MapKit
import SwiftUI

@Observable
final class MapViewModel {
    let nycCoordinates: CLLocationCoordinate2D = .init(latitude: 40.7128, longitude: -74.006)
    
    let nycPolygonBoxCoords: [CLLocationCoordinate2D] = [
        .init(latitude: 40.746318, longitude: -74.005167),
        .init(latitude: 40.74346, longitude: -73.97716),
        .init(latitude: 40.71768, longitude: -73.97669),
        .init(latitude: 40.71971, longitude: -74.00943),
    ]
    
    var circleOverlayCenterCoordinates: [CLLocationCoordinate2D] = [
        .init(latitude: 40.746318, longitude: -74.005167),
        .init(latitude: 40.74346, longitude: -73.97716),
        .init(latitude: 40.71768, longitude: -73.97669),
        .init(latitude: 40.71971, longitude: -74.00943),
    ]
    
    var nycCameraPosition: MapCameraPosition
    
    var currentCoordinates: CLLocationCoordinate2D
    
    var shouldShowOverlays: Bool = true
    
    init() {
        self.nycCameraPosition = MapCameraPosition.region(.init(center: nycCoordinates, span: .init(latitudeDelta: 0.05, longitudeDelta: 0.05)))
        self.currentCoordinates = nycCoordinates
    }
    
    func addCurrentCoordinatesToOverlays() {
        circleOverlayCenterCoordinates.append(currentCoordinates)
    }
}
