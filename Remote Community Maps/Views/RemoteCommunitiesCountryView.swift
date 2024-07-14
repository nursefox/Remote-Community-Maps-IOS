////
////  RemoteCommunitiesCountryView.swift
////  Remote Community Maps
////
////  Created by Benjamin Fox on 14/7/2024.
////
//
//import MapKit
//import SwiftUI
//
//struct RemoteCommunitiesCountryView: View {
//    
//    let remoteCommunties: RemoteCommunitiesContainer
//
//    
//    @State private var cameraPosition: MapCameraPosition = .automatic
//    @State private var mapSelection: MKMapItem?
//    @State private var selectedTag: String?
//    
//    var body: some View {
//        NavigationStack {
//            Map(position: $cameraPosition, selection: $selectedTag) {
//                UserAnnotation()
//                
//                withAnimation {
//                    ForEach(remoteCommunties.remoteCommunities, id:\.self) { remoteCommunity in
//                        Marker( remoteCommunity.communityName , coordinate: remoteCommunity.coordinate)
//                            .tag(remoteCommunity.communityName)
//                    }
//                }
//            }
//        }
//        .onChange(of: selectedTag, { oldValue, newValue in
//            print ("mapSelection.name = " + String (newValue!))
//        })
//    }
//}
//
//#Preview {
//    RemoteCommunitiesCountryView()
//}
