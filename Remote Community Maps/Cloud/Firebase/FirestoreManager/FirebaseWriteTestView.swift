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
    
    //@EnvironmentObject var authService: AuthenticationManager
    
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
        
        var remoteCommunity = CloudModelRemoteCommunity (name: remoteCommunity.name.replacingOccurrences(of: " ", with: "-"),
                                                         traditionalName: remoteCommunity.traditionalName,
                                                         state: remoteCommunity.state.replacingOccurrences(of: " ", with: "_") ,
                                                         latitude: remoteCommunity.latitude,
                                                         longitude: remoteCommunity.longitude,
                                                         latitudinalMeters: remoteCommunity.latitudinalMeters,
                                                         longitudinalMeters: remoteCommunity.longitudinalMeters,
                                                         mapDataFileName: remoteCommunity.mapDataFileName,
                                                         imageFileName: remoteCommunity.imageFileName,
                                                         published: remoteCommunity.published)
        
        
        do {
            //try firestoreManager.db.collection("remote-communities").document(remoteCommunity.state + "-" + remoteCommunity.name ).setData(from: remoteCommunity)
            
//            try firestoreManager.db
//                .collection ("remote-communities").document(remoteCommunity.state)
//                .collection ("places").document(remoteCommunity.name).setData (from: remoteCommunity)
            
            try firestoreManager.db
                .collection ("remote-communities")
                .document(remoteCommunity.state.lowercased())
                .collection (remoteCommunity.name.lowercased())
                .document(remoteCommunity.name).setData(from: remoteCommunity)
                
                
            for lot in sortedLots {
                
                var lotInfo = CloudLotInformation()
                lotInfo.name = lot.name
                lotInfo.details = lot.details
                lotInfo.latitude = lot.latitude
                lotInfo.longitude = lot.longitude
                lotInfo.colourDescriptor = lot.colourDescriptor
                
                try firestoreManager.db
                    .collection ("remote-communities")
                    .document(remoteCommunity.state.lowercased())
                    .collection (remoteCommunity.name.lowercased())
                    .document (lotInfo.name).setData (from: lotInfo)
                
//                var lotInfo = CloudLotInformation()
//                lotInfo.name = lot.name
//                lotInfo.details = lot.details
//                lotInfo.latitude = lot.latitude
//                lotInfo.longitude = lot.longitude
//                lotInfo.colourDescriptor = lot.colourDescriptor
//        
//                remoteCommunity.lotData.append(lotInfo)
            }
                
                
            
            
            
        } catch let error {
          print("Error writing remote community to Firestore: \(error)")
        }
        
        print ("Data saved to firestore successfully!")
        
        
        
        
//        var remoteCommunity = CloudModelRemoteCommunity (name: "Santa Teresa",
//                                                         traditionalName: "Ltyentye Apurte",
//                                                         state: "NT",
//                                                         latitude: -23.94583428030692,
//                                                         longitude: 132.7795533845188,
//                                                         latitudinalMeters: 1100,
//                                                         longitudinalMeters: 1350,
//                                                         mapDataFileName: "Lot Data - Hermannsburg - NT.geojson",
//                                                         imageFileName: "Profile Photo - Hermannsburg - NT",
//                                                         published: true)
//           
//        var lotInfo = CloudLotInformation()
//        lotInfo.name = "278"
//        lotInfo.details = "Clinic"
//        lotInfo.latitude = 55
//        lotInfo.longitude = 100
//        lotInfo.colourDescriptor = "Blue"
//        
//        remoteCommunity.lotData.append(lotInfo)
//    
//        
//        var lotInfo2 = CloudLotInformation()
//        lotInfo2.name = "125"
//        lotInfo2.details = "Police Station"
//        lotInfo2.latitude = 134.3703423
//        lotInfo2.longitude = -24.1294314
//        lotInfo2.colourDescriptor = "White"
//        
//        remoteCommunity.lotData.append(lotInfo2)
//        
//        
//        do {
//            try firestoreManager.db.collection("remote-communities").document(remoteCommunity.state + "-" + remoteCommunity.name ).setData(from: remoteCommunity)
//            
//        } catch let error {
//          print("Error writing remote community to Firestore: \(error)")
//        }
//        
//        print ("Data saved to firestore successfully!")
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
