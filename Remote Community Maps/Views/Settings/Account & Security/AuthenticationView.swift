//
//  SignInMethodView.swift
//  Remote Community Maps
//
//  Created by Benjamin Fox on 23/2/2024.
//


import FirebaseCore
import GoogleSignIn
import GoogleSignInSwift
import SwiftUI
import UIKit

private enum FocusableField: Hashable {
    case email
    case password
}

struct AuthenticationView: View {
    
    @StateObject private var viewModel = AuthenticationViewModel()
    
    //@FocusState private var focus: FocusableField?
    @State private var email = ""
    @State private var password = ""
    @State private var error: Swift.Error?
    
    //@State private var showSignInView: Bool = false
    
    @Environment(\.dismiss) var dismiss
    
    @Binding var showSignInView: Bool
    
    
    var body: some View {
        
        VStack {
            Image("RCMIcon")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(minHeight: 75, maxHeight: 75)
            
            //Divider()
            
            HStack {
                TextField("Email", text: $email)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            HStack {
                SecureField("Password", text: $password)
                //.focused($focus, equals: .password)
                    .submitLabel(.go)
                    .onSubmit {
                        print ( "Calling sign in method")
                    }
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            Button {
                Task {
                    do {
                        try await signIntoAuthenticationServer()
                        //showSignInView = false
                    } catch {
                        print ("Sign in Error with attempting to sign into account")
                        print (error)
                    }
                }
            } label: {
                Text ("Sign In")
                    .font(.headline)
                    .frame(height: 40)
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.white)
                    .background(.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            }
            
            HStack {
                GoogleSignInButton(scheme: .light, style: .wide, state: .normal) {
                    Task {
                        do {
                            try await viewModel.signIntoGoogle()
                            showSignInView = false
                            print ("Successfully signed into Google")
                        } catch {
                            print (error)
                        }
                    }
                }
            }
            
            Divider()
            
            Button(action: {
                Task {
                    do {
                        try await viewModel.signInApple()
                        showSignInView = false
                    } catch {
                        print (error)
                    }
                }
            }, label: {
                SignInWithAppleButtonRepresentable(type: .default, style: .whiteOutline)
                    .allowsHitTesting(false)
            })
            .frame (height: 50)
            
            
            
            Button (action: {
                Task {
                    do {
                        try await viewModel.signInAnonymous()
                        //showSignInView = false
                        print ("Successfully signed in anonymously")
                    } catch {
                        print (error)
                    }
                }
            }, label: {
                Text ("Sign in Anonymously")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
            })
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.gray, lineWidth: 1)
            )
            .frame (height: 50)
            
            
            
            
            Divider()
            
            NavigationLink {
                //SignUpViewEmailView(showSignInView: $showSignInView)
                SignUpViewEmailView()
            } label: {
                Text ("Don't have an account yet?")
                Text ("Sign Up")
                    .fontWeight(.semibold)
                    .foregroundStyle(.blue)
            }
            .padding([.top, .bottom], 50)
            .foregroundStyle(.black)
            
            Spacer()
            
        }
        .errorAlert(error: $error)
        .toolbar {
            ToolbarItem(placement: .cancellationAction, content: cancelButton)
        }
        .padding()
        //.navigationTitle("Sign In")
        .accentColor(.black)
        .toolbarBackground(.white, for: .navigationBar) //<- Set background
        .toolbarBackground(.visible, for: .navigationBar)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Sign in to Community Maps")
        .navigationBarBackButtonHidden()
    }
    
    // the cancel button
    func cancelButton() -> some View {
        Button { dismiss() } label: { Image(systemName: "xmark").fontWeight(.bold) }
    }
    
    
    func signIntoAuthenticationServer() async throws {
        
        // The user is telling us they have an account - lets check it out
        guard !email.isEmpty else {
            print ("Email Not Entered")
            self.error = AuthenticationManager.AuthenticationError.emailEmpty
            throw MyError.runtimeError("Email has not been entered")
        }
        
        if !email.isValidEmail {
            print ("Email failed Validation")
            self.error = AuthenticationManager.AuthenticationError.emailFailedValidation
            throw MyError.runtimeError("Email is not in a valid format")
        }
        
        guard !password.isEmpty else {
            print ("Password is empty")
            self.error = AuthenticationManager.AuthenticationError.passwordEmpty
            throw MyError.runtimeError("Password is empty")
        }
        
        //        let (userAuthInfo, isNewUser) = try await AuthManager.shared.signInEmail(emailAddress: email, password: password)
        
        let returnedUserData = try await AuthenticationManager.shared.signInUser(email: email, password: password)
        
        print ("Success")
        print (returnedUserData)
    }
}

#Preview {
    NavigationStack {
        
        AuthenticationView(showSignInView: .constant(false))
        //AuthenticationView()
    }
}
