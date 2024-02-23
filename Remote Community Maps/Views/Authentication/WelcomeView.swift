//
//  WelcomeView.swift
//  Remote Community Maps
//
//  Created by Benjamin Fox on 21/2/2024.
//

import SwiftUI

struct WelcomeView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @EnvironmentObject var authService: AuthenticationManager
    
    var body: some View {
        
        ZStack {
            Color.gray
                .ignoresSafeArea()
                .opacity(0.5)
            
            VStack {
                
                if authService.signedIn {
                    Text("Already Signed In")
                } else {
                    Text("Not Signed In")
                }
                
                
                TextField("Email", text: $email)
                    .textFieldStyle(.roundedBorder)
                SecureField("Password", text: $password)
                    .textFieldStyle(.roundedBorder)
                
                Button("Create an Account") {
                    authService.regularCreateAccount(email: email, password: password)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                
                HStack {
                    Text("Already have an account? ")
                    
                    NavigationLink(destination: LoginView()) {
                        Text("Login").foregroundColor(.blue)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .padding()
        }
    }
}

#Preview {
    NavigationStack {
        WelcomeView().environmentObject(AuthenticationManager.shared)
    }
}
