//
//  SettingsView.swift
//  Remote Community Maps
//
//  Created by Benjamin Fox on 22/2/2024.
//

import SwiftUI

struct SettingsView: View {
    
    @Binding var showSignInView: Bool
    var body: some View {
        List {
            Button ("Log Out") {
                
                Task {
                    do {
                        try logOut()
                        showSignInView = true
                    } catch {
                        print (error)
                    }
                }
            }
        }
        .navigationTitle("Settings")
    }
    
    func logOut () throws {
        try AuthenticationManager.shared.signOut()
    }
}

#Preview {
    NavigationStack {
        SettingsView(showSignInView: .constant(true))
    }
}
