//
//  EditPointOfInterestLocationView.swift
//  Remote Community Maps
//
//  Created by Benjamin Fox on 28/12/2023.
//

import MapKit
import SwiftData
import SwiftUI

struct EditPointOfInterestLocationView: View {
    
    @Environment(\.modelContext) var modelContex
    @Environment(\.dismiss) var dismiss
    
    @Bindable var remoteCommunity: RemoteCommunity
    @Bindable var lotInfo: LotInformation
    
    
    @State private var cameraPosition: MapCameraPosition = .region(.userRegion)
    
    @State private var updatedPOILocation = MKPointAnnotation()
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
        //NavigationStack {
        VStack {
            MapViewUpdateLocation(community: remoteCommunity,
                                  lotInformation: lotInfo,
                                  mapType: mapType,
                                  draftPOI: $updatedPOILocation,
                                  draftPOILatitude: $lat,
                                  draftPOIlongitude: $long)
            .overlay (alignment: .bottom){
                VStack ( alignment: .center ) {
                    
                    //                        Text ("Latitude = " + lat)
                    //                        Text ("Longitude = " + long)
                    
                    HStack (alignment: .top ) {
                        Button("Save New Pin Location", action: newPOILocationConfirmed )
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
        //  }
        .onAppear() {
            cameraPosition = .region(remoteCommunity.region)
            print ("Camera Position Latitude : " + String ( remoteCommunity.region.center.latitude ))
            print ("Camera Position Longitude : " + String ( remoteCommunity.region.center.longitude ))
            
            lat = String(updatedPOILocation.coordinate.latitude)
            long = String(updatedPOILocation.coordinate.longitude)
            
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
                                        newPOIAnnotation: updatedPOILocation,
                                        lotInfoSaved: $lotInfoSaved)
        }
        .onChange(of: lotInfoSaved) {
            dismiss()
        }
    }
    
    func newPOILocationConfirmed () {
        
        print ("Saving new Location of POI")
        
        lotInfo.latitude = updatedPOILocation.coordinate.latitude
        lotInfo.longitude = updatedPOILocation.coordinate.longitude
        
        dismiss()
        
        
        //        lat = String(updatedPOILocation.coordinate.latitude)
        //        long = String(updatedPOILocation.coordinate.longitude)
        //
        //        isShowingPOIDetails = true
        // Bring up a bottom sheet for the user to enter the POI's details
    }
    
    func saveLotInformation () {
        print ("Saving new Location of POI")
        
        lotInfo.latitude = updatedPOILocation.coordinate.latitude
        lotInfo.longitude = updatedPOILocation.coordinate.longitude
        
        dismiss()
    }
    
}

struct MapViewUpdateLocation: UIViewRepresentable {
    
    @Bindable var community: RemoteCommunity
    @Bindable var lotInformation: LotInformation
    let mapType: MKMapType
    
    @Binding var draftPOI: MKPointAnnotation
    @Binding var draftPOILatitude: String
    @Binding var draftPOIlongitude: String
    
    func makeUIView(context: Context) -> MKMapView {
        
        print ("Inside makeUIView()")
        
        let map = MKMapView()
        
        draftPOI.coordinate = lotInformation.lotCoordinates
        //draftPOI.coordinate = community.region.center
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
        
        var parent: MapViewUpdateLocation
        
        init(_ parent: MapViewUpdateLocation) {
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
    SingleItemPreview<RemoteCommunity> { community in // set the type
        EditPointOfInterestLocationView(remoteCommunity: community, lotInfo: community.lotData.first!)
        // add your view with the item
    }
    .modelContainer(DataController.previewContainer)
    .environmentObject(LocationDataManager.preview)
    
}
