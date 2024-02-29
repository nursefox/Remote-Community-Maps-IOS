//
//  RootView.swift
//  Remote Community Maps
//
//  Created by Benjamin Fox on 22/2/2024.
//

import SwiftUI

struct RootView: View {
    
    @State private var showSignInView: Bool = false
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        
        //ZStack {
            if AuthenticationManager.shared.signedIn {
                SettingsView()
                //SettingsView(showSignInView: $showSignInView)
            } else {
                SignInMethodView()
                //SignInMethodView(showSignInView: $showSignInView)
            }
        //}
        
        //ZStack {
//            if AuthenticationManager.shared.signedIn {
//                SettingsView(showSignInView: $showSignInView)
//            }
//            } else {
//                self.showSignInView = true
//                SignInMethodView(showSignInView: $showSignInView)
//            }
            
        
        

//            if AuthenticationManager.shared.signedIn {
//                SettingsView(showSignInView: $showSignInView)
//            }
////            SettingsView(showSignInView: $showSignInView)
//        }
//        .onAppear {
//            let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
//            self.showSignInView = authUser == nil
//            print ( authUser == nil )
//            
//            self.showSignInView = true
//        }
//        .sheet(isPresented: $showSignInView) {
//            NavigationStack {
//                SignInMethodView(showSignInView: $showSignInView)
//                //AuthenticationView(showSignInView: $showSignInView)
//            }
//        }
//        .toolbar {
//            ToolbarItem(placement: .cancellationAction, content: cancelButton)
//        }
//        .accentColor(.black)
//        .toolbarBackground(.white, for: .navigationBar) //<- Set background
//        .toolbarBackground(.visible, for: .navigationBar)
//        .navigationBarTitleDisplayMode(.inline)
//        .navigationTitle("Root View")
    }
    
    // the cancel button
    func cancelButton() -> some View {
        Button { dismiss() } label: { Image(systemName: "xmark").fontWeight(.bold) }
    }
   
}

#Preview {
    NavigationStack {
        RootView()
    }
}
