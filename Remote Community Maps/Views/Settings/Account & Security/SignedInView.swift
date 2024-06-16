//
//  SignedInView.swift
//  Remote Community Maps
//
//  Created by Benjamin Fox on 26/2/2024.
//

import SwiftUI

struct SignedInView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            
            Form {
                
                Text ("User Is Authenticated")
                
                Section("User ID:") {
                    displayAuthenticatedUserId()
                }
                
                Section("Account Details") {
                    displayAuthenticatedUserEmail()
                }
                
                
                
                if AuthenticationManager.shared.signedIn {
                    Section("Account") {
                        List {
                            Button {
                                Task {
                                    do {
                                        try logOut()
                                        //self.showSignInView = true
                                        print ( "User Signed Out")
                                    } catch {
                                        print (error)
                                    }
                                }
                            } label: {
                                HStack {
                                    Image(systemName: "rectangle.portrait.and.arrow.right")
                                        .foregroundStyle(.red)
                                    Text ("Log Out")
                                        .foregroundStyle(.red)
                                }
                            }
                            
                            
                            Button {
                                Task {
                                    do {
                                        try await resetPassword()
                                        print ("Password has been reset")
                                    } catch {
                                        print (error)
                                    }
                                }
                            } label: {
                                HStack {
                                    Image(systemName: "lock.open.rotation")
                                    Text ("Reset Password")
                                }
                            }
                        }
                    }
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
        
    }
    
    // the cancel button
    func cancelButton() -> some View {
        Button { dismiss() } label: { Image(systemName: "xmark").fontWeight(.bold) }
    }
    
    func logOut () throws {
        try AuthenticationManager.shared.signOut()
    }
    
    
    
    func resetPassword() async throws {
        let authUser = try AuthenticationManager.shared.getAuthenticatedUser()
        
        guard let email = authUser.email else {
            throw URLError(.fileDoesNotExist)
        }
        
        try await AuthenticationManager.shared.resetPassword(email: email)
    }
    
    
    func displayAuthenticatedUserEmail() -> some View {
        
        var userEmail = ""
        
        do {
            let user = try AuthenticationManager.shared.getSignedInUser()
            userEmail = user.email ?? ""
            //return Text (user.email ?? "")
        } catch {
            //return Text ("Sign in Error with attempting to sign into account")
            return Text ("")
        }
        return Text (userEmail)
    }
    
    
    func displayAuthenticatedUserId() -> some View {
        var userID = ""
        
        do {
            let user = try AuthenticationManager.shared.getAuthenticatedUser()
            userID = user.uid
            print ("User ID: \(userID)")
        } catch {
            print (error)
            return Text ("")
        }
        return Text (userID)
    }
}

#Preview {
    SignedInView()
}
