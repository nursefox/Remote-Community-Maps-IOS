//
//  RemoteCommunityMapAllLocationsView.swift
//  Remote Community Maps
//
//  Created by Benjamin Fox on 17/12/2023.
//

import MapKit
import SwiftUI
import CoreLocation

struct RemoteCommunityMapAllLocationsView: View {
    
    @Environment(\.modelContext) var modelContex
    @Bindable var remoteCommunity: RemoteCommunity
    
    @State private var searchText: String = ""
    @State private var showSearch: Bool = false
    @State private var cameraPosition: MapCameraPosition = .region(.userRegion)
    
    @State private var selectedMapOption: MapOptions = .standard
    @State private var mapMarkerCoordinate: MKCoordinateRegion = .userRegion
    @State private var annotatationsArray = [LotInformation]()
    @State private var searchResults = [MKMapItem]()
    @State private var selectedItem: MKMapItem?
    @State private var route: MKRoute?
    @State private var isShowingBottomSheet = false
    @State private var selectedTag: String?
    
    @FocusState private var houseToFindIsFocused: Bool
    
    @Environment(\.dismissSearch) var dismissSearch
    
    var body: some View {
        
        VStack {
            Map(position: $cameraPosition, selection: $selectedTag) {
                UserAnnotation()
                
                withAnimation {
                    ForEach(remoteCommunity.lotData, id:\.self) { lotInfo in
                        Marker(lotInfo.name, coordinate: lotInfo.lotCoordinates)
                            .tag(lotInfo.name)
                    }
                }
            }
            //            .onTapGesture {
            //                print ("Map was clicked")
            //                hideKeyboard()
            //
            //            }
            .mapControls {
                MapCompass()
                MapPitchToggle()
                MapUserLocationButton()
            }
            .mapStyle(selectedMapOption.mapStyle)
            Picker("Map Styles", selection: $selectedMapOption) {
                ForEach (MapOptions.allCases) { mapOption in
                    Text (mapOption.rawValue.capitalized).tag(mapOption)
                }
            }
            .pickerStyle(.segmented)
            .navigationTitle(remoteCommunity.name)
            .navigationBarTitleDisplayMode(.inline)
            .searchable( text: $searchText, isPresented:  $showSearch).focused($houseToFindIsFocused)
            .onChange(of: searchText) {
                print("Search Field changed to \($searchText.wrappedValue)")
                
                annotatationsArray.removeAll()
                
                // Search the JSON to see if we find a match
                if let lotInfo = remoteCommunity.lotData.first(where: {$0.name == (searchText.uppercased())}) {
                    
                    // Found a match - Create a mapmarker
                    annotatationsArray.append(lotInfo)
                    
                    withAnimation {
                        selectedItem = MKMapItem(placemark: MKPlacemark(coordinate: lotInfo.lotCoordinates))
                        selectedItem?.name = lotInfo.name
                        cameraPosition = .region(MKCoordinateRegion(center: lotInfo.lotCoordinates, latitudinalMeters: 500, longitudinalMeters: 500))
                    }
                } else {
                    withAnimation {
                        cameraPosition = .region(remoteCommunity.region)
                    }
                }
            }
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
        }
        .onAppear() {
            cameraPosition = .region(remoteCommunity.region)
            print ("Camera Position Latitude : " + String ( remoteCommunity.region.center.latitude ))
            print ("Camera Position Longitude : " + String ( remoteCommunity.region.center.longitude ))
        }
        .sheet (isPresented: $isShowingBottomSheet, content: {
            Button("Navigate", action: activateNavigation)
                .buttonStyle(.bordered)
                .buttonBorderShape(.roundedRectangle)
                .tint(.blue)
                .controlSize(.small)
                .presentationDetents([.height(100)])
                .presentationCornerRadius(12)
            
        })
        .onChange(of: selectedTag, { oldValue, newValue in
            
            if let newValue {
                print ("mapSelection.name = " + String (newValue))
                isShowingBottomSheet = true
            } else {
                isShowingBottomSheet = false
            }
        })
    }
    
    func activateNavigation() {
        
        isShowingBottomSheet = false
        selectedItem?.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
    }
}

extension CLLocationCoordinate2D {
    static var userLocation: CLLocationCoordinate2D {
        return .init(latitude: -23.20451, longitude: 131.91195)
    }
}

extension MKCoordinateRegion {
    static var userRegion: MKCoordinateRegion {
        return .init(center: .userLocation,
                     latitudinalMeters: 1200,
                     longitudinalMeters: 1200)
    }
}


enum MapOptions: String, Identifiable, CaseIterable {
    case standard
    case hybrid
    case imagery
    
    var id: String {
        self.rawValue
    }
    
    var mapStyle: MapStyle {
        switch self {
        case .standard:
            return .standard
        case .hybrid:
            return .hybrid
        case .imagery:
            return .imagery
        }
    }
    
    var mapStyleImage: String {
        switch self {
        case .standard:
            return "map"
        case .hybrid:
            return "square.3.layers.3d"
        case .imagery:
            return "globe"
        }
    }
    
}

#Preview {
    NavigationStack {
        SingleItemPreview<RemoteCommunity> { community in // set the type
            RemoteCommunityMapAllLocationsView(remoteCommunity: community) // add your view with the item
        }
        .modelContainer(DataController.previewContainer)
        .environmentObject(LocationDataManager.preview)
    }
}
