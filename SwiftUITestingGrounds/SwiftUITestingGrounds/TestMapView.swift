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
    @State var mapSearchService = SearchableMapLocationService()
    
    var body: some View {
//        testMapView
        basicMapView
            .sheet(isPresented: .constant(true)) {
                MapSearchCompletionSheetView(
                    mapSearchService: $mapSearchService,
                    position: $mapSearchService.position
                )
            }
            .animation(.default, value: mapSearchService.selectedLocation)
    }
    
    @ViewBuilder
    var basicMapView: some View {
        MapReader { mapProxy in
            Map(position: $mapSearchService.position) {
                
                if let selectedLocation = mapSearchService.selectedLocation {
                    Marker(coordinate: selectedLocation.location) {
                        Image(systemName: "mappin")
                    }
                    .tag(selectedLocation)
                }
            }
            .mapControls {
                MapUserLocationButton()
                MapScaleView()
                MapCompass()
                    .mapControlVisibility(.visible)
                MapPitchToggle()
            }
        }
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
                .gesture(
                    SpatialTapGesture()
                        .onEnded { screenCoord in
                            print("Tapped map - screencoord: \(screenCoord)")
                        }
                )
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

extension CLLocationCoordinate2D: @retroactive Hashable, @retroactive Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        lhs.latitude == rhs.latitude &&
        lhs.longitude == rhs.longitude
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(latitude)
        hasher.combine(longitude)
    }
}

// MARK: -- Map search completion sheet
struct MapSearchCompletionSheetView: View {
    @Binding var mapSearchService: SearchableMapLocationService
    @FocusState var searchFieldFocused: Bool
    @State var shouldShowCancelButton: Bool = false
    
    private let smallDetent: PresentationDetent = .height(75)
    @State private var currentSheetDetent: PresentationDetent = .height(75)
    
    @Binding var position: MapCameraPosition
    
    private var availableDetents: Set<PresentationDetent> {
        return [smallDetent, .medium]
    }
    
    var body: some View {
        VStack {
            HStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                    TextField("Search for a location", text: $mapSearchService.searchText)
                        .focused($searchFieldFocused, equals: true)
                }
                .padding(12)
                .background(.gray.opacity(0.1))
                .cornerRadius(8)
                .foregroundStyle(.primary)
                
                if shouldShowCancelButton {
                    Button("Cancel") {
                        searchFieldFocused = false
                        mapSearchService.searchText = ""
                        mapSearchService.update(queryFragment: "")
                        currentSheetDetent = smallDetent
                        // TODO: reset search results as well
                    }
                    .transition(.offset(x: 100))
                }
            }
            
            searchList
        }
        .animation(.spring(duration: 0.25), value: shouldShowCancelButton)
        .padding(.horizontal)
        .padding(.top, 16)
        .interactiveDismissDisabled()
        .presentationBackgroundInteraction(.enabled)
        .presentationDetents(
            availableDetents,
            selection: $currentSheetDetent
        )
        
        .onChange(of: searchFieldFocused) { oldValue, newValue in
            shouldShowCancelButton = newValue
            
            if newValue == true {
                currentSheetDetent = .medium
            }
        }
        .onChange(of: currentSheetDetent) { oldValue, newValue in
            if newValue == smallDetent {
                searchFieldFocused = false
            }
        }
        
        .onChange(of: mapSearchService.searchText) { oldValue, newValue in
            mapSearchService.update(queryFragment: newValue)
        }
        .onChange(of: mapSearchService.selectedLocation) { oldValue, newValue in
            if let newValue {
                mapSearchService.updatePositionFor(selectedLocation: newValue)
            } else {
                position = .automatic
            }
        }
        
    }
    
    @ViewBuilder
    var searchList: some View {
        List {
            ForEach(mapSearchService.searchCompletions) { completion in
                Button {
                    mapSearchService.setLocationFromSidebarCompletion(completion)
                } label: {
                    VStack(alignment: .leading) {
                        Text(completion.title)
                            .font(.headline)
                        Text(completion.subTitle)
                            .foregroundStyle(.secondary)
                            .font(.system(size: 16))
                    }
                }
            }
        }
        .listStyle(.plain)
        .contentMargins(.leading, -16, for: .scrollContent)
        .contentMargins(.bottom, 16, for: .scrollContent)
        .scrollIndicators(.hidden)
        .opacity(currentSheetDetent == smallDetent ? 0 : 1)
    }
}
