//
//  FirebaseWriteTestView.swift
//  Remote Community Maps
//
//  Created by Benjamin Fox on 22/2/2024.
//

import FirebaseCore
import FirebaseFirestore
import SwiftUI

struct FirebaseWriteTestView: View {
    
    @StateObject var authService = AuthenticationManager.shared
    @StateObject var firestoreManager = FirestoreManager.shared

    let remoteCommunity: RemoteCommunity
    
    var sortedLots: [LotInformation] {
        remoteCommunity.lotData.sorted {
            $0.name < $1.name
        }
    }
    
    var body: some View {
        
        VStack {
            Button {
                Task {
                    await saveDataToFirestore()
                }
            } label: {
                Text ("Save Firestore data")
            }
            .buttonStyle(.bordered)
            .buttonBorderShape(.roundedRectangle)
            .tint(.teal)
            .controlSize(.small)
        }
        .navigationBarTitle(remoteCommunity.name, displayMode: .inline)
    }
    
    func saveDataToFirestore () async {
        
        let remoteCommunity = CloudModelRemoteCommunity (name: remoteCommunity.name.replacingOccurrences(of: " ", with: "_"),
                                                         traditionalName: remoteCommunity.traditionalName,
                                                         state: remoteCommunity.state.replacingOccurrences(of: " ", with: "_") ,
                                                         country: remoteCommunity.country,
                                                         latitude: remoteCommunity.latitude,
                                                         longitude: remoteCommunity.longitude,
                                                         latitudinalMeters: remoteCommunity.latitudinalMeters,
                                                         longitudinalMeters: remoteCommunity.longitudinalMeters,
                                                         mapDataFileName: remoteCommunity.mapDataFileName,
                                                         imageFileName: remoteCommunity.imageFileName,
                                                         published: remoteCommunity.published)
        
        do {
            
            let country = remoteCommunity.country.lowercased().replacingOccurrences(of: " ", with: "_")
            let state = remoteCommunity.state.lowercased().replacingOccurrences(of: " ", with: "_")
            let communityName = remoteCommunity.name.lowercased().replacingOccurrences(of: " ", with: "_")
            
            try firestoreManager.db.document("remote_communities/countries/\(country)/\(state)/\(communityName)/community_details").setData (from: remoteCommunity)

            for lot in sortedLots {
                
                var lotInfo = CloudLotInformation()
                lotInfo.name = lot.name
                lotInfo.details = lot.details
                lotInfo.latitude = lot.latitude
                lotInfo.longitude = lot.longitude
                lotInfo.colourDescriptor = lot.colourDescriptor
                
                try firestoreManager.db.document("remote_communities/countries/\(country)/\(state)/\(communityName)/community_details/lot_data/\(lotInfo.name)").setData (from: lotInfo)
            }
        } catch let error {
          print("Error writing remote community to Firestore: \(error)")
        }
        
        print ("Data saved to firestore successfully!")
    }
}

#Preview {
    
    NavigationStack {
        SingleItemPreview<RemoteCommunity> { community in // set the type
            FirebaseWriteTestView(remoteCommunity: community) // add your view with the item
        }
        .modelContainer(DataController.previewContainer)
        .environmentObject(AuthenticationManager.shared)
        .environmentObject(FirestoreManager.shared)
    }
}
