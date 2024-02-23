//
//  SwiftTestView.swift
//  Remote Community Maps
//
//  Created by Benjamin Fox on 23/12/2023.
//

import MapKit
import SwiftUI
import CoreLocation

struct RemoteCommunitySearchView: View {
    @Environment(\.modelContext) var modelContex
    @Bindable var remoteCommunity:RemoteCommunity
    
    @State private var activeLotInfoSelected: LotInformation?
    
    //@State private var searchText: String = ""
    @State private var showSearch: Bool = false
    
    @State private var lotIdBeingSearched = ""
    
    @State private var cameraPosition: MapCameraPosition = .region(.userRegion)
    //    @State private var cameraPosition: MapCameraPosition = .userLocation(fallback: .automatic)
    
    @State private var selectedMapOption: MapOptions = .standard
    @State private var mapMarkerCoordinate: MKCoordinateRegion = .userRegion
    @State private var annotatationsArray = [LotInformation]()
    @State private var searchResults = [MKMapItem]()
    @State private var selectedItem: MKMapItem?
    @State private var route: MKRoute?
    
    @State private var selectedTag: String?
    
    @State private var isShowingBottomSheet = false
    
    
    @FocusState private var houseToFindIsFocused: Bool
    
    @Environment(\.dismissSearch) var dismissSearch
    
    
    var body: some View {
        ZStack (alignment: .topTrailing) {
            
            Menu {
                Picker("Map Styles", selection: $selectedMapOption) {
                    ForEach (MapOptions.allCases) { mapOption in
                        Text (mapOption.rawValue.capitalized).tag(mapOption)
                    }
                }
            } label: {
                Image(systemName: selectedMapOption.mapStyleImage)
                    .font(.title3)
                    .padding([.leading, .trailing], 7)
                    .padding([.top, .bottom], 10)
                    .background(.white)
                    .cornerRadius(8)
                    .opacity(0.8)
            }
            .menuOrder(.fixed)
            .offset(x:-5, y:115)
            .zIndex(1)
            
            Map(position: $cameraPosition, selection: $selectedTag) {
                UserAnnotation()
                
                withAnimation {
                    ForEach(annotatationsArray, id:\.self) { lotInfo in
                        Marker(lotInfo.name, coordinate: lotInfo.lotCoordinates)
                            .tag(lotInfo.name)
                    }
                }
            }
            .zIndex(0)
            .mapControls {
                //MapCompass()
                MapPitchToggle()
                MapUserLocationButton()
            }
            .onMapCameraChange { mapCameraUpdateContext in
                print("\(mapCameraUpdateContext.camera.centerCoordinate)")
            }
            .mapStyle(selectedMapOption.mapStyle)
            .overlay (alignment: .bottom){
                VStack ( alignment: .center ) {
                    HStack (alignment: .top ) {
                        
                        Button("House Details", action: displayLotDetails )
                            .buttonStyle(.bordered)
                            .buttonBorderShape(.roundedRectangle)
                            .disabled(!canBeNavigated())
                            .tint(.teal)
                            .controlSize(.small)
                        
                        Button("Navigate", action: activateNavigation)
                            .buttonStyle(.bordered)
                            .buttonBorderShape(.roundedRectangle)
                            .disabled(!canBeNavigated())
                            .tint(.blue)
                            .controlSize(.small)
                    }
                    .frame(maxWidth: .infinity, maxHeight: 65, alignment: .center)
                    .background(.white)
                }
                .navigationTitle("Search For Location")
                .navigationBarTitleDisplayMode(.inline)
                .searchable( text: $lotIdBeingSearched, isPresented: $showSearch).focused($houseToFindIsFocused)
                .onChange(of: lotIdBeingSearched) {
                    searchForLot()
                }
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
            }
        }
        .onAppear() {
            cameraPosition = .region(remoteCommunity.region)
            print ("Camera Position Latitude : " + String ( remoteCommunity.region.center.latitude ))
            print ("Camera Position Longitude : " + String ( remoteCommunity.region.center.longitude ))
        }
        .sheet (isPresented: $isShowingBottomSheet){
            NavigationStack {
                SheetHouseDetailsView (lotInfo: annotatationsArray.first!)
            }
            .presentationDetents([.height(275)])
            .presentationCornerRadius(12)
            .presentationDragIndicator(.hidden)
        }
        .onChange(of: selectedTag, { oldValue, newValue in
            if let newValue {
                print ("mapSelection.name = " + String (newValue))
                isShowingBottomSheet = true
            } else {
                isShowingBottomSheet = false
            }
        })
    }
    
    
    func displayLotDetails () {
        isShowingBottomSheet = true
    }
    
    func searchForLot () {
        print("Search Field changed to \($lotIdBeingSearched.wrappedValue)")
        
        annotatationsArray.removeAll()
        
        // Search the JSON to see if we find a match
        if let lotInfo = remoteCommunity.lotData.first(where: {$0.name == (lotIdBeingSearched.uppercased())}) {
            
            // Found a match - Create a mapmarker
            annotatationsArray.append(lotInfo)
            lotIdBeingSearched = lotInfo.name
            
            activeLotInfoSelected = lotInfo
            
            withAnimation {
                selectedItem = MKMapItem(placemark: MKPlacemark(coordinate: lotInfo.lotCoordinates))
                selectedItem?.name = lotInfo.name
                cameraPosition = .region(MKCoordinateRegion(center: lotInfo.lotCoordinates, latitudinalMeters: 500, longitudinalMeters: 500))
            }
        } else {
            withAnimation {
                //lotIdBeingSearched = ""
                cameraPosition = .region(remoteCommunity.region)
            }
        }
    }
    
    // The save button is disabled until the user has entered at least one character
    
    func canBeNavigated () -> Bool {
        if remoteCommunity.lotData.first(where: {$0.name == (lotIdBeingSearched.uppercased())}) != nil {
            return true
        } else {
            return false
        }
    }
    
    
    
    func activateNavigation() {
        isShowingBottomSheet = false
        selectedItem?.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
    }
}

#Preview {
    NavigationStack {
        SingleItemPreview<RemoteCommunity> { community in // set the type
            RemoteCommunitySearchView(remoteCommunity: community) // add your view with the item
        }
        .modelContainer(DataController.previewContainer)
        .environmentObject(LocationDataManager.preview)
    }
}
