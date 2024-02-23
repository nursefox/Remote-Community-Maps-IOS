//
//  HomeView.swift
//  Remote Community Maps
//
//  Created by Benjamin Fox on 21/2/2024.
//

import Firebase
import SwiftUI

struct HomeView: View {
    @EnvironmentObject var authService: AuthenticationManager
    
    var body: some View {
        
        Text (Auth.auth().currentUser?.email ?? "Not Logged In")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Log out") {
                    print("Log out tapped!")
                    authService.regularSignOut { error in
                        
                        if let e = error {
                            print(e.localizedDescription)
                        }
                    }
                }
            }
        }
    }
    
    //    func getCurrentUser() {
    //        let user = Auth.auth().currentUser
    //        if let user = user {
    //            // The user's ID, unique to the Firebase project.
    //            // Do NOT use this value to authenticate with your backend server,
    //            // if you have one. Use getTokenWithCompletion:completion: instead.
    //            let uid = user.uid
    //            let email = user.email
    //            let photoURL = user.photoURL
    //            var multiFactorString = "MultiFactor: "
    //            for info in user.multiFactor.enrolledFactors {
    //                multiFactorString += info.displayName ?? "[DispayName]"
    //                multiFactorString += " "
    //            }
    //        }
    //    }
}

#Preview {
    NavigationStack {
        HomeView().environmentObject(AuthenticationManager.shared)
    }
}
