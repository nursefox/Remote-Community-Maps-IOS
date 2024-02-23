//
//  FirestoreManager.swift
//  Remote Community Maps
//
//  Created by Benjamin Fox on 22/2/2024.
//

import Foundation
import Firebase

class FirestoreManager: ObservableObject {

    let db = Firestore.firestore()
    
    static let shared: FirestoreManager = FirestoreManager()
    
    func saveRemoteCommunity( remoteCommunity: RemoteCommunity) {
        do {
            try db.collection("rewmote-communities").document(remoteCommunity.name).setData(from: remoteCommunity)
        } catch let error {
          print("Error writing remote community to Firestore: \(error)")
        }
    }
    
}
