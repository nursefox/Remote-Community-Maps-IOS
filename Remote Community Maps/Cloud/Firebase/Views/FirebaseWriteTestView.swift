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

    var body: some View {
        
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
    
    func saveDataToFirestore () async {
        
        var remoteCommunity = CloudModelRemoteCommunity (name: "Santa Teresa",
                                                         traditionalName: "Ltyentye Apurte",
                                                         state: "NT",
                                                         latitude: -23.94583428030692,
                                                         longitude: 132.7795533845188,
                                                         latitudinalMeters: 1200,
                                                         longitudinalMeters: 1600,
                                                         mapDataFileName: "Lot Data - Hermannsburg - NT.geojson",
                                                         imageFileName: "Profile Photo - Hermannsburg - NT",
                                                         published: true)
           
        var lotInfo = CloudLotInformation()
        lotInfo.name = "278"
        lotInfo.details = "Clinic"
        lotInfo.latitude = 55
        lotInfo.longitude = 200
        lotInfo.colourDescriptor = "Blue"
        
        remoteCommunity.lotData.append(lotInfo)
    
        
        var lotInfo2 = CloudLotInformation()
        lotInfo2.name = "125"
        lotInfo2.details = "Police Station"
        lotInfo2.latitude = 134.3703423
        lotInfo2.longitude = -24.1294314
        lotInfo2.colourDescriptor = "White"
        
        remoteCommunity.lotData.append(lotInfo2)
        
        do {
            try firestoreManager.db.collection("remote-communities").document(remoteCommunity.state + "-" + remoteCommunity.name ).setData(from: remoteCommunity)
            
        } catch let error {
          print("Error writing remote community to Firestore: \(error)")
        }
        
        print ("Data saved to firestore successfully!")
    }
}

#Preview {
    FirebaseWriteTestView()
        .environmentObject(AuthenticationManager.shared)
        .environmentObject(FirestoreManager.shared)
}
