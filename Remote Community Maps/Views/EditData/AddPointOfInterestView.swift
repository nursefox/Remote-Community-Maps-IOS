//
//  AddPOITestView.swift
//  Remote Community Maps
//
//  Created by Benjamin Fox on 26/12/2023.
//

import MapKit
import SwiftUI

struct AddPointOfInterestView: View {
    
    @Environment(\.modelContext) var modelContex
    @Environment(\.dismiss) var dismiss
    let remoteCommunity: RemoteCommunity
    
    @State private var cameraPosition: MapCameraPosition = .region(.userRegion)
    
    @State private var newPOIAnnotation = MKPointAnnotation()
    @State private var lat = ""
    @State private var long = ""
    @State private var isShowingPOIDetails = false
    
    @State private var lotName = ""
    @State private var lotDescription = ""
    @State private var lotColour = ""
    
    // @State private var selectedMapOption: MapOptions = .standard
    @State private var mapType: MKMapType = .standard
    
    @State private var lotInfoSaved = false
    
    var body: some View {
        
        VStack {
            MapView(community: remoteCommunity,
                    mapType: mapType,
                    draftPOI: $newPOIAnnotation,
                    draftPOILatitude: $lat,
                    draftPOIlongitude: $long)
            .overlay (alignment: .bottom){
                VStack ( alignment: .center ) {
                    
                    //                        Text ("Latitude = " + lat)
                    //                        Text ("Longitude = " + long)
                    
                    HStack (alignment: .top ) {
                        Button("Confirm Pin Location", action: newPOILocationConfirmed )
                        //.buttonStyle(.bordered)
                            .buttonBorderShape(.roundedRectangle)
                            .tint(.green)
                            .buttonStyle(.borderedProminent)
                            .controlSize(.regular)
                    }
                    .frame(maxWidth: .infinity, maxHeight: 65, alignment: .center)
                    .background(.white)
                }
            }
        }
        
        .onAppear() {
            cameraPosition = .region(remoteCommunity.region)
            print ("Camera Position Latitude : " + String ( remoteCommunity.region.center.latitude ))
            print ("Camera Position Longitude : " + String ( remoteCommunity.region.center.longitude ))
            
            lat = String(newPOIAnnotation.coordinate.latitude)
            long = String(newPOIAnnotation.coordinate.longitude)
            
            mapType = .standard
        }
        .toolbar {
            ToolbarItem (placement: .topBarTrailing) {
                
                Menu("Map Style", systemImage: "gear", content: {
                    Picker("", selection: $mapType) {
                        Text("Standard").tag(MKMapType.standard)
                            .tag(0)
                        Text("Satellite").tag(MKMapType.satellite)
                            .tag(1)
                        Text("Hybrid").tag(MKMapType.hybrid)
                            .tag(2)
                    }
                    .pickerStyle(.inline)
                })
            }
        }
        .sheet (isPresented: $isShowingPOIDetails) {
            EnterNewLotInformationSheet(remoteCommunity: remoteCommunity,
                                        newPOIAnnotation: newPOIAnnotation,
                                        lotInfoSaved: $lotInfoSaved)
        }
        .onChange(of: lotInfoSaved) {
            dismiss()
        }
    }
    
    func newPOILocationConfirmed () {
        lat = String(newPOIAnnotation.coordinate.latitude)
        long = String(newPOIAnnotation.coordinate.longitude)
        
        isShowingPOIDetails = true
        // Bring up a bottom sheet for the user to enter the POI's details
    }
    
    
}


struct EnterNewLotInformationSheet: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContex
    
    @Bindable var remoteCommunity: RemoteCommunity
    let newPOIAnnotation: MKPointAnnotation
    @Binding var lotInfoSaved: Bool
    
    @FocusState private var fieldFocus: Bool
    
    @State private var lotName = ""
    @State private var lotDescription = ""
    @State private var lotColour = ""
    
    @State private var lotDetailsSaved = false
    
    var body: some View {
        VStack (alignment: .center ) {
            Form {
                Section ("Enter New Lot Information") {
                    HStack (alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/ ) {
                        TextField ("Lot Identifier", text: $lotName)
                            .foregroundColor(.purple)
                            .focused($fieldFocus)
                    }
                    
                    HStack {
                        TextField ("Lot Description", text: $lotDescription)
                            .foregroundColor(.black)
                    }
                    
                    HStack {
                        TextField ("Lot Colour", text: $lotColour)
                            .foregroundColor(.blue)
                    }
                    
                    HStack (alignment: .top) {
                        Spacer()
                        Button("Save New Lot", action: saveLotInformation)
                        //                            .buttonStyle(.bordered)
                        //                            .buttonBorderShape(.roundedRectangle)
                            .disabled(!canBeSaved)
                            .tint(.blue)
                            .buttonStyle(.borderedProminent)
                            .controlSize(.regular)
                        Spacer()
                    }
                }
                .presentationDetents([.height(225)])
                .presentationCornerRadius(12)
                .presentationDragIndicator(.visible)
            }
        }
        .onAppear{
            print ("onAppear - sheet")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                fieldFocus = true
            }
        }
    }
    
    // The save button is disabled until the user has entered at least one character
    var canBeSaved: Bool { lotName.count > 0 }
    
    func saveLotInformation () {
        print ("Updating Lot Information")
        
        let newLotInfo = LotInformation(name: lotName,
                                        details: lotDescription,
                                        latitude: newPOIAnnotation.coordinate.latitude,
                                        longitude: newPOIAnnotation.coordinate.longitude,
                                        colourDescriptor: lotColour,
                                        unitIdentifier: "")
        newLotInfo.remoteCommunity = remoteCommunity
        
        modelContex.insert(newLotInfo)
        //try? modelContex.save()
        lotInfoSaved = true
        dismiss()
        
    }
}


struct MapView: UIViewRepresentable {
    
    let community: RemoteCommunity
    let mapType: MKMapType
    
    @Binding var draftPOI: MKPointAnnotation
    @Binding var draftPOILatitude: String
    @Binding var draftPOIlongitude: String
    
    func makeUIView(context: Context) -> MKMapView {
        
        print ("Inside makeUIView()")
        
        let map = MKMapView()
        
        draftPOI.coordinate = community.region.center
        draftPOI.title = "Drag Me To Your Desired Location"
        
        map.mapType = mapType
        map.region = community.region
        map.showsUserLocation = true
        map.addAnnotation(draftPOI)
        map.delegate = context.coordinator
        map.selectAnnotation(draftPOI, animated: true)
        
        return map
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        print ("updateUIView () : Start")
        mapView.mapType = mapType
        
        // remove all existing annotations
        mapView.removeAnnotations(mapView.annotations)
        withAnimation {
            mapView.addAnnotation(draftPOI)
            mapView.selectAnnotation(draftPOI, animated: true)
        }
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        
        var parent: MapView
        
        init(_ parent: MapView) {
            self.parent = parent
        }
        
        func mapView(_ map: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if annotation is MKUserLocation { return nil }   // let the OS show user locations itself
            
            let marker = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "marker")
            marker.isDraggable = true
            marker.markerTintColor = .red
            marker.animatesWhenAdded = true
            marker.canShowCallout = true
            
            return marker
        }
        
        
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
            
            print ("Inside Drag Check")
            
            switch newState {
            case .starting:
                view.dragState = .dragging
            case .ending, .canceling:
                //New cordinates
                print(view.annotation?.coordinate as Any)
                
                if let newCoordinate = view.annotation?.coordinate {
                    parent.draftPOILatitude = String(newCoordinate.latitude)
                    parent.draftPOIlongitude = String(newCoordinate.longitude)
                    parent.draftPOI.coordinate = newCoordinate
                }
                
                view.dragState = .none
            default: break
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}

#Preview {
    NavigationStack {
        SingleItemPreview<RemoteCommunity> { community in // set the type
            AddPointOfInterestView(remoteCommunity: community) // add your view with the item
        }
        .modelContainer(DataController.previewContainer)
        .environmentObject(LocationDataManager.preview)
    }
}

