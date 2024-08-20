//
//  ContentView.swift
//  SwiftUITestingGrounds
//
//  Created by Kevin Vu on 5/16/24.
//

import SwiftUI
import MapKit

struct TestMapView: View {
    
    @Namespace var mapScope
    @State var mapViewModel = MapViewModel()
    
    var body: some View {
//        testMapView
        basicMapView
    }
    
    @ViewBuilder
    var basicMapView: some View {
        MapReader { mapProxy in
            Map(position: $mapViewModel.nycCameraPosition) {
//                Marker("", systemImage: "photo", coordinate: mapViewModel.nycCoordinates)
                    
                Marker(coordinate: mapViewModel.nycCoordinates) {
                    Image(systemName: "video")
                }
                .tint(.blue)
            }
            .mapControls {
                MapUserLocationButton()
                MapScaleView()
                MapCompass()
                    .mapControlVisibility(.visible)
                MapPitchToggle()
            }
        }
        .simultaneousGesture(
            TapGesture()
                .onEnded {
                    print("Tapped simultaneous gesture!")
                }
        )
    }
    
    @ViewBuilder
    var testMap: some View {
        VStack {
            MapReader { mapProxy in
                Map(position: $mapViewModel.nycCameraPosition) {
                    MapPolygon(coordinates: mapViewModel.nycPolygonBoxCoords)
                        .foregroundStyle(.yellow.opacity(0.3))

                    ForEach(mapViewModel.circleOverlayCenterCoordinates, id: \.self) { coord in
                        MapCircle(center: coord, radius: 500)
                            .foregroundStyle(mapViewModel.shouldShowOverlays ? .red.opacity(0.3) : .clear)
                    }
                }
//                .simultaneousGesture(
//                    SpatialTapGesture()
//                        .onEnded { screenCoord in
//                            print("Tapped map - screencoord: \(screenCoord)")
//                        }
//                )
                .onTapGesture { screenCoord in
                    print("Tapped map - screencoord")
                }
                .mapStyle(.standard(elevation: .realistic))
                .onMapCameraChange { context in
                    mapViewModel.currentCoordinates = context.region.center
//                    print("Context region center: \(context.region.center)")
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            HStack(alignment: .center) {
                Button {
                    guard mapViewModel.shouldShowOverlays else { return }
                    print("ADDING CIRCLE TO MAP")
                    mapViewModel.addCurrentCoordinatesToOverlays()
                } label: {
                    Text("Add circle overlay")
                        .font(.headline)
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding(.top)
                        .padding(.horizontal)
                }
                
                Button {
                    mapViewModel.shouldShowOverlays.toggle()
                } label: {
                    Text("Toggle overlays")
                        .font(.headline)
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding(.top)
                        .padding(.horizontal)
                }
            }
            .background(.black)
        }
    }
}

#Preview {
    TestMapView()
}

extension CLLocationCoordinate2D: Hashable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        lhs.latitude == rhs.latitude &&
        lhs.longitude == rhs.longitude
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(latitude)
        hasher.combine(longitude)
    }
}
