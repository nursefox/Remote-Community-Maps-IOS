//
//  LoginView.swift
//  Remote Community Maps
//
//  Created by Benjamin Fox on 21/2/2024.
//


import Firebase
import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @EnvironmentObject var authService: AuthenticationManager
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        ZStack {
            Color.gray
                .ignoresSafeArea()
                .opacity(0.5)
            
            VStack {
                TextField("Email", text: $email)
                    .textFieldStyle(.roundedBorder)
            
                SecureField("Password", text: $password)
                    .textFieldStyle(.roundedBorder)
                
                Button("Login") {
                    authService.regularSignIn(email: email, password: password) { error in
                        if let e = error {
                            print(e.localizedDescription)
                        }
                    }
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                
                HStack {
                    Text("Don't have an account?")
                    
                    Button {
                        dismiss()
                    } label: {
                        Text("Create Account").foregroundColor(.blue)
                    }
                }.frame(maxWidth: .infinity, alignment: .center)
            }
        }
    }
}

#Preview {
    NavigationStack {
        LoginView()
    }
}
