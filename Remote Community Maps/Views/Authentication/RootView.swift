//
//  RootView.swift
//  Remote Community Maps
//
//  Created by Benjamin Fox on 22/2/2024.
//

import SwiftUI

struct RootView: View {
    
    @State private var showSignInView: Bool = false
    
    var body: some View {
        ZStack {
            SettingsView(showSignInView: $showSignInView)
        }
        .onAppear {
            let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
            self.showSignInView = authUser == nil
        }
        .fullScreenCover(isPresented: $showSignInView) {
            NavigationStack {
                SignInMethodView(showSignInView: $showSignInView)
                //AuthenticationView(showSignInView: $showSignInView)
            }
        }
    }
}

#Preview {
    NavigationStack {
        RootView()
    }
}
