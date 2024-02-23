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
        ZStack {
            SettingsView(showSignInView: $showSignInView)
        }
        .onAppear {
            let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
            self.showSignInView = authUser == nil
        }
        .sheet(isPresented: $showSignInView) {
            NavigationStack {
                SignInMethodView(showSignInView: $showSignInView)
                //AuthenticationView(showSignInView: $showSignInView)
            }
        }
        .accentColor(.black)
        .toolbarBackground(.white, for: .navigationBar) //<- Set background
        .toolbarBackground(.visible, for: .navigationBar)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("House Details")
    }
    
   
}

#Preview {
    NavigationStack {
        RootView()
    }
}
