//
//  AccountSettingsView.swift
//  Remote Community Maps
//
//  Created by Benjamin Fox on 25/2/2024.
//

import SwiftUI

struct AccountSettingsAndSecurityView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var firstName = ""
    @State private var lastName = ""
    
    @State private var showSignInView: Bool = false
    
    var body: some View {
        VStack {
            
            
            Form {
                
                if AuthenticationManager.shared.signedIn {
                    displayAuthenticatedUserEmail()
                } else {
                    Text ("User Is NOT Signed In")
                    
                    //AuthenticationView()
                    AuthenticationView(showSignInView: $showSignInView)
                    //SignInMethodView(showSignInView: $showSignInView)
                }
                
             //   TextField("First Name", text: $firstName)
             //  TextField("Last Name", text: $lastName)
            }
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction, content: cancelButton)
        }
        .accentColor(.black)
        .toolbarBackground(.white, for: .navigationBar) //<- Set background
        .toolbarBackground(.visible, for: .navigationBar)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Acccount & Security")
        .navigationBarBackButtonHidden()
        
    }
    
    // the cancel button
    func cancelButton() -> some View {
        Button { dismiss() } label: { Image(systemName: "xmark").fontWeight(.bold) }
    }
    
    
    func displayAuthenticatedUserEmail() -> some View {
        
        var userEmail = ""
        
        do {
            let user = try AuthenticationManager.shared.getSignedInUser()
            userEmail = user.email ?? ""
            //return Text (user.email ?? "")
        } catch {
            return Text ("Sign in Error with attempting to sign into account")
        }
        return Text (userEmail)
    }
}

#Preview {
    NavigationStack {
        AccountSettingsAndSecurityView()
    }
}
