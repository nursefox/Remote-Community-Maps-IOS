//
//  LotDetailAndMapView.swift
//  Remote Community Maps
//
//  Created by Benjamin Fox on 2/1/2024.
//

import MapKit
import SwiftUI

struct LotDetailAndMapView: View {
    
    @Environment(\.modelContext) var modelContex
    
    @Bindable var lotInfo: LotInformation
    
    @State private var lotName = ""
    @State private var lotDesription = ""
    @State private var lotColour = ""
    
    @State private var cameraPosition: MapCameraPosition = .region(.userRegion)
    
    @State private var selectedMapOption: MapOptions = .standard
    @State private var mapMarkerCoordinate: MKCoordinateRegion = .userRegion
    
    @State private var selectedItem: MKMapItem?
    @State private var selectedTag: String?
    
    
    @FocusState private var houseToFindIsFocused: Bool
    
    
    @Environment(\.dismissSearch) var dismissSearch
    
    
    var body: some View {
        VStack (alignment: .center ) {
            Form {
                List {
                    HStack {
                        
                        //LabeledContent("Lot ID", value: lotInfo.lotName).foregroundColor(.teal).bold()
                        
                        Text ("Name:")
                        Spacer()
                        Text (lotInfo.name).foregroundColor(.teal).bold()
                    }
                    
                    HStack {
                        Text ("Description:")
                        Spacer()
                        Text (lotInfo.details).foregroundColor(.purple).bold()
                    }
                    
                    HStack {
                        Text ("Colour Descriptor:")
                        Spacer()
                        Text (lotInfo.colourDescriptor ?? "").foregroundColor(.blue).bold()
                    }
                    
                    HStack {
                        Text ("Latitude:")
                        Spacer()
                        Text (String(format: "%.4f", lotInfo.latitude)).foregroundColor(.blue).bold()
                    }
                    
                    HStack {
                        Text ("Longitude:")
                        Spacer()
                        Text (String(format: "%.4f", lotInfo.longitude)).foregroundColor(.blue).bold()
                    }
                }
            }
            .listStyle(.plain)
            .frame(height: 275)
        }
        
        Map(position: $cameraPosition, selection: $selectedTag) {
            UserAnnotation()
            
            withAnimation {
                Marker(lotInfo.name, coordinate: lotInfo.lotCoordinates)
                    .tag(lotInfo.name)
            }
        }
        .mapControls {
            MapCompass()
            MapPitchToggle()
            MapUserLocationButton()
        }
        .mapStyle(selectedMapOption.mapStyle)
        .onAppear() {
            
            cameraPosition = .region(MKCoordinateRegion(center: lotInfo.lotCoordinates, latitudinalMeters: 1000, longitudinalMeters: 1000))
            
            selectedItem = MKMapItem(placemark: MKPlacemark(coordinate: lotInfo.lotCoordinates))
            selectedItem?.name = lotInfo.name
            
            
            //cameraPosition = .region(lotInfo.remoteCommunity!.region)
            print ("Camera Position Latitude : " + String ( lotInfo.remoteCommunity!.region.center.latitude ))
            print ("Camera Position Longitude : " + String ( lotInfo.remoteCommunity!.region.center.longitude ))
        }
        
        .overlay (alignment: .bottom){
            VStack ( alignment: .center ) {
                HStack (alignment: .top ) {

                    Button("Navigate", action: activateNavigation)
                        .buttonStyle(.bordered)
                        .buttonBorderShape(.roundedRectangle)
                        .tint(.blue)
                        .controlSize(.small)

                }
                .frame(maxWidth: .infinity, maxHeight: 65, alignment: .center)
                .background(.white)
            }
        }
        
    }
    
    func activateNavigation() {
    
        selectedItem?.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
    }
}

#Preview {
    NavigationStack {
        SingleItemPreview<LotInformation> { lotInfo in // set the type
            LotDetailAndMapView(lotInfo: lotInfo)
        }
        .modelContainer(DataController.previewContainer)
        .environmentObject(LocationDataManager.preview)
    }
}
