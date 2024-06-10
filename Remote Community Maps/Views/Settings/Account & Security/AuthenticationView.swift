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

@MainActor
final class AuthenticationViewModel: ObservableObject {
    
    let signInAppleHelper = SignInAppleHelper()
    
    func signIntoGoogle() async throws {
        let helper = SignInGoogleHelper()
        let tokens = try await helper.signIn()
        try await AuthenticationManager.shared.signInWithGoogle(tokens: tokens)
    }
    
    func signInApple() async throws {
        let helper = SignInAppleHelper()
        let tokens = try await helper.startSignInWithAppleFlow()
        try await AuthenticationManager.shared.signInWithApple(tokens: tokens)
    }
    
    func signIntoEmail() async throws {
        
    }
    
    func signInAnonymous() async throws {
        try await AuthenticationManager.shared.signInAnonymous()
    }
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
            Image("Login")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(minHeight: 150, maxHeight: 200)
            
            Divider()
            
            HStack {
                TextField("Email", text: $email)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                //.focused($focus, equals: .email)
                //                    .submitLabel(.next)
                //                    .onSubmit {
                //                        self.focus = .password
                //                    }
            }
            .padding(.vertical, 6)
            .background(Divider(), alignment: .bottom)
            .padding(.bottom, 4)
            
            HStack {
                SecureField("Password", text: $password)
                //.focused($focus, equals: .password)
                    .submitLabel(.go)
                    .onSubmit {
                        print ( "Calling sign in method")
                    }
            }
            .padding(.vertical, 6)
            .background(Divider(), alignment: .bottom)
            .padding(.bottom, 8)
            
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
                Text ("Log In")
                    .font(.headline)
                    .frame(height: 40)
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.white)
                    .background(.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            }
            Divider()
            
            Text ("Or")
                .padding([.top, .bottom], 20)
            
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
                    .frame(height: 40)
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.white)
                    .background(.teal)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            })
            
            
            GoogleSignInButton(scheme: .dark, style: .wide, state: .normal) {
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
                SignInWithAppleButtonRepresentable(type: .default, style: .black)
                    .allowsHitTesting(false)
            })
            .frame (height: 55)
            
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
        .navigationTitle("Login")
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
