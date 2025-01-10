//
//  SearchableMapLocationService.swift
//  SwiftUITestingGrounds
//
//  Created by Kevin Vu on 11/7/24.
//

import SwiftUI
@preconcurrency import MapKit

struct SearchableMapSearchCompletion: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let subTitle: String
    let searchCompletion: MKLocalSearchCompletion
    let mapItem: MKMapItem
    
    var completionCoordinate: CLLocationCoordinate2D {
        return mapItem.placemark.coordinate
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct SearchableMapSearchResult: Identifiable, Hashable {
    let id = UUID()
    let location: CLLocationCoordinate2D

    static func == (lhs: SearchableMapSearchResult, rhs: SearchableMapSearchResult) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

@MainActor
@Observable
final class SearchableMapLocationService: NSObject, @preconcurrency MKLocalSearchCompleterDelegate {
    private let completer: MKLocalSearchCompleter
    
    var searchText: String = ""
    var searchCompletions: [SearchableMapSearchCompletion] = []
    var displayedSearchCompletions: [SearchableMapSearchCompletion] = []
    var searchResults: [SearchableMapSearchResult] = []
    var selectedLocation: SearchableMapSearchResult?
    
    var position: MapCameraPosition = .automatic
    
    var displayPosition: MapCameraPosition {
        guard let region = position.region else { return position }
        
        let adjustedLongitude = region.center.longitude - 0.01
        let adjustedCameraPosition = MapCameraPosition.region(
            .init(
                center: .init(
                    latitude: region.center.latitude,
                    longitude: adjustedLongitude
                ),
                span: region.span
            )
        )
        return adjustedCameraPosition
    }
    
    init(completer: MKLocalSearchCompleter = .init()) {
        self.completer = completer
        super.init()
        self.completer.delegate = self
    }
    
    func setLocation(_ location: CLLocationCoordinate2D?) {
        if let location {
            DebugLog.line("\(String(describing: type(of: self))):\(#function) - Found address and coordinate from existing event, populating selected location")/
            selectedLocation = .init(location: location)
        }
    }
    
    func update(queryFragment: String) {
        completer.queryFragment = queryFragment
        
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchCompletions = completer.results.compactMap {
            guard $0.subtitle != "Search Nearby" else {
                return nil
            }
            
            guard let mapItem = $0.value(forKey: "_mapItem") as? MKMapItem else {
                DebugLog.line("\(String(describing: type(of: self))):\(#function) - Couldn't extract map item from local search completion")/
                return nil
            }
            
            return .init(
                title: $0.title,
                subTitle: $0.subtitle,
                searchCompletion: $0,
                mapItem: mapItem
            )
        }
    }
    
    func didFinalizeSearch() {
        displayedSearchCompletions = searchCompletions
    }
    
    func search(with query: String, coordinate: CLLocationCoordinate2D? = nil) async throws -> [SearchableMapSearchResult] {
        let mapKitRequest = MKLocalSearch.Request()
        mapKitRequest.naturalLanguageQuery = query
        mapKitRequest.resultTypes = .pointOfInterest
        if let coordinate {
            mapKitRequest.region = .init(.init(origin: .init(coordinate), size: .init(width: 1, height: 1)))
        }
        let search = MKLocalSearch(request: mapKitRequest)
        
        let response = try await search.start()
        
        return response.mapItems.compactMap { mapItem in
            guard let location = mapItem.placemark.location?.coordinate else { return nil }
            
            return .init(location: location)
        }
    }
    
    func setLocationFromSidebarCompletion(_ searchCompletion: SearchableMapSearchCompletion) {
        Task(priority: .userInitiated) {
            if let searchCoordinate = await search(withCompletion: searchCompletion.searchCompletion) {
                selectedLocation = .init(location: searchCoordinate)
            } else {
                selectedLocation = .init(location: searchCompletion.completionCoordinate)
            }
        }
    }
    
    private func search(withCompletion completion: MKLocalSearchCompletion) async -> CLLocationCoordinate2D? {
        let searchRequest = MKLocalSearch.Request(completion: completion)
        let search = MKLocalSearch(request: searchRequest)
        
        do {
            let response = try await search.start()
            let firstMapItem = response.mapItems.first
            return firstMapItem?.placemark.coordinate
        } catch let error {
            DebugLog.errorWithDesc("\(String(describing: type(of: self))):\(#function) - Failed to start search for completion: \(completion)", error)/
            return nil
        }
    }
    
    func updateResults(withQuery query: String, coordinate: CLLocationCoordinate2D? = nil) async {
        do {
            searchResults = try await search(with: query, coordinate: coordinate)
        } catch let error {
            DebugLog.errorWithDesc("\(String(describing: type(of: self))):\(#function) - Failed to update results for query: \(query) - ", error)/
            
        }
    }
    
    func updatePositionFor(selectedLocation: SearchableMapSearchResult) {
        let targetDelta = 0.075
        var targetSpan = position.region?.span ?? .init(latitudeDelta: targetDelta, longitudeDelta: targetDelta)
        
        if targetSpan.longitudeDelta > targetDelta {
            targetSpan = .init(latitudeDelta: targetDelta, longitudeDelta: targetDelta)
        }
        
        let adjustedLatitude = selectedLocation.location.latitude - 0.03
        position = MapCameraPosition.region(
            .init(
                center: .init(
                    latitude: adjustedLatitude,
                    longitude: selectedLocation.location.longitude
                ),
                span: targetSpan
            )
        )
    }
}

