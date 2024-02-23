//
//  StartView.swift
//  Remote Community Maps
//
//  Created by Benjamin Fox on 21/2/2024.
//

import SwiftUI

import SwiftUI
import FirebaseAuth

struct StartView: View {
    @EnvironmentObject var authService: AuthenticationManager
    
    var body: some View {
        
        if authService.signedIn {
            HomeView()
        } else {
            WelcomeView()
        }
    }
}

#Preview {
    NavigationStack {
        WelcomeView().environmentObject(AuthenticationManager.shared)
    }
}


//    @StateObject var authService = AuthService()
//
//    if authService.signedIn {
//        HomeView()
//    } else {
//        WelcomeView()
//    }
//}
