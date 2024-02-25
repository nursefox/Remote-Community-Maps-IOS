//
//  SettingsView.swift
//  Remote Community Maps
//
//  Created by Benjamin Fox on 22/2/2024.
//

import SwiftUI

struct SettingsView: View {
    
    @Binding var showSignInView: Bool
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        VStack (alignment: .center) {
            Form {

                
                
                
                Button {
                    print ("Profile")
                } label :  {
                    HStack {
                        Image(systemName: "person.fill")
                            .foregroundStyle(.blue)
                        Text ("Profile")
                    }
                }
                
                Button {
                    print ("Account & Security")
                } label :  {
                    HStack {
                        Image(systemName: "lock.fill")
                            .foregroundStyle(.blue)
                        Text ("Account & Security")
                    }
                }
                
                

                
                Button {
                    print ("Email & Notifications")
                } label :  {
                    HStack {
                        Image(systemName: "bell.fill")
                            .foregroundStyle(.blue)
                        Text ("Email & Notifications")
                    }
                }
                
                
                Button {
                    print ("Privacy & Legal Terms")
                } label :  {
                    HStack {
                        Image(systemName: "eye.slash.circle")
                            .foregroundStyle(.blue)
                        Text ("Privacy & Legal Terms")
                    }
                }
                
                Button {
                    print ("Help")
                } label :  {
                    HStack {
                        Image(systemName: "questionmark.circle")
                            .foregroundStyle(.blue)
                        Text ("Help")
                    }
                }
                
                
                Section("Other") {
             
                    Button {
                        print ("Favourites Clicked")
                    } label :  {
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundStyle(.blue)
                            Text ("Favourites")
                        }
                    }
                    
                    Button {
                        print ("Download Offline Maps")
                    } label :  {
                        HStack {
                            Image(systemName:  "square.and.arrow.down")
                                .foregroundStyle(.blue)
                            Text("Download Offline Maps")
                        }
                    }
                    
                    
               }
                
                Section("Account") {
                    List {
                        Button {
                            Task {
                                do {
                                    try logOut()
                                    self.showSignInView = true
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
        .navigationTitle("Settings")
        
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



}

#Preview {
    NavigationStack {
        SettingsView(showSignInView: .constant(true))
    }
}
