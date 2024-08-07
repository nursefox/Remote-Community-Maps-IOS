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
    //@State private var showSearch: Bool = true
    
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
    @State private var searchableIsDisabled = false
    
    //@FocusState private var houseToFindIsFocused: Bool
    
    @Environment(\.dismissSearch) var dismissSearch
    
    @State var showCancelButton = false
    // @Binding var text: String
    
    
    var body: some View {
        
        VStack (alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/) {
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
                    MapPitchToggle()
                    MapUserLocationButton()
                }
                .onMapCameraChange { mapCameraUpdateContext in
                    // print("\(mapCameraUpdateContext.camera.centerCoordinate)")
                }
                .mapStyle(selectedMapOption.mapStyle)
            }
            
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
            .padding (.bottom, 10)
            
            
        }
        .searchable(text: $lotIdBeingSearched).disabled(searchableIsDisabled).autocorrectionDisabled().keyboardType(.asciiCapable)
        .navigationTitle("Search For House")
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: lotIdBeingSearched) {
            searchForLot()
        }
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
        .onAppear() {
            cameraPosition = .region(remoteCommunity.region)
            print ("Camera Position Latitude : " + String ( remoteCommunity.region.center.latitude ))
            print ("Camera Position Longitude : " + String ( remoteCommunity.region.center.longitude ))
        }
        .sheet (isPresented: $isShowingBottomSheet, onDismiss: {searchableIsDisabled = false}){
            SheetHouseDetailsView (lotInfo: annotatationsArray.first!, searchableFieldDisabled: searchableIsDisabled)
                .presentationDetents([.height(275)])
                .presentationCornerRadius(12)
                .presentationDragIndicator(.hidden)
            
            
            //  .ignoresSafeArea(.keyboard, edges: .bottom)
            
        }
        //        .onChange(of: selectedTag, { oldValue, newValue in
        //            if let newValue {
        //                print ("mapSelection.name = " + String (newValue))
        //                isShowingBottomSheet = true
        //            } else {
        //                isShowingBottomSheet = false
        //            }
        //        })
    }
    
    var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass").foregroundColor(.gray)
            TextField("Search", text: $lotIdBeingSearched)
                .font(Font.system(size: 21))
                .onTapGesture {
                    withAnimation {
                        showCancelButton = true
                    }
                }
                .autocorrectionDisabled().keyboardType(.asciiCapable)
        }
        .padding(7)
        //.background(Color.searchBarColor)
        .background(Color(.systemFill).opacity(0.5))
        .cornerRadius(10)
    }
    
    
    func displayLotDetails () {
        
        searchableIsDisabled = true
        isShowingBottomSheet = true
        // hideKeyboard()
        // UIApplication.shared.endEditing()
    }
    
    func searchForLot () {
        print("Search Field changed to \($lotIdBeingSearched.wrappedValue)")
        
        let searchTerm = $lotIdBeingSearched.wrappedValue
        
        
        if searchTerm.isEmpty {
            print ("Doing nothing - search term empty")
            annotatationsArray.removeAll()
            
            withAnimation {
                cameraPosition = .region(remoteCommunity.region)
            }
            
            
        } else {
            
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
                
                // We didn't find an exact match on house number - let's search for house colour
                let lotsFound = remoteCommunity.lotData.filter({ $0.colourDescriptor?.uppercased() == lotIdBeingSearched.uppercased() })
                
                if lotsFound.count > 0 {
                    for lotInfo in lotsFound {
                        
                        annotatationsArray.append(lotInfo)
                        // lotIdBeingSearched = lotInfo.name
                        //activeLotInfoSelected = lotInfo
                        
                        withAnimation {
                            
                            selectedItem = MKMapItem(placemark: MKPlacemark(coordinate: lotInfo.lotCoordinates))
                            selectedItem?.name = lotInfo.name + "(\( lotInfo.colourDescriptor!)"
                            
                            
                            if lotsFound.count == 1 {
                                cameraPosition = .region(MKCoordinateRegion(center: lotInfo.lotCoordinates, latitudinalMeters: 500, longitudinalMeters: 500))
                            }
                        }
                    
                    }
                } else {
                    withAnimation {
                        cameraPosition = .region(remoteCommunity.region)
                    }
                }
            }
        }
        
        
        
        // Search the JSON to see if we find a match - now this time searching colour
        //        if let lotInfo = remoteCommunity.lotData.first(where: {$0.colourDescriptor == (lotIdBeingSearched.uppercased())}) {
        //
        //            // Found a match - Create a mapmarker
        //            annotatationsArray.append(lotInfo)
        //            lotIdBeingSearched = lotInfo.name
        //
        //            activeLotInfoSelected = lotInfo
        //
        //            withAnimation {
        //                selectedItem = MKMapItem(placemark: MKPlacemark(coordinate: lotInfo.lotCoordinates))
        //                selectedItem?.name = lotInfo.name
        //                cameraPosition = .region(MKCoordinateRegion(center: lotInfo.lotCoordinates, latitudinalMeters: 500, longitudinalMeters: 500))
        //            }
        //        } else {
        //            withAnimation {
        //                //lotIdBeingSearched = ""
        //                cameraPosition = .region(remoteCommunity.region)
        //            }
        //        }
        
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

struct TextFieldGrayBackgroundColor: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(12)
            .background(.gray.opacity(0.1))
            .cornerRadius(8)
            .foregroundColor(.primary)
    }
}
