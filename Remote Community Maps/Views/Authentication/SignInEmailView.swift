//
//  SignInEmailView.swift
//  Remote Community Maps
//
//  Created by Benjamin Fox on 22/2/2024.
//

import SwiftUI

struct SignInEmailView: View {
    
    @State private var email = ""
    @State private var password = ""
    @State private var passwordConfirmation = ""
    @State private var signUpFlag = false
    
    @State private var initialFlag = false
    
    @State private var error: Swift.Error?
    
    @Binding var showSignInView: Bool
    
    var body: some View {
        VStack {
            TextField ("Email ...", text: $email)
                .textCase(.lowercase)
                .autocapitalization(.none)
                .padding()
                .background(Color.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            
            TextField ("Password ...", text: $password)
                .padding()
                .background(Color.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            
            if (signUpFlag == true) {
                TextField ("Confirm Password ...", text: $passwordConfirmation)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            }
            
            Button {
                Task {
                    // Sign In - Attempt to log into existing account
                    if (signUpFlag == true) {
                        // Sign Up - Create a new account
                        do {
                            try await signIntoAuthenticationServer()
                            showSignInView = false
                        } catch {
                            print ("Sign in Error with attempting to create new account")
                            print (error)
                        }
                    } else {
                        do {
                            try await signIntoAuthenticationServer()
                            showSignInView = false
                        } catch {
                            print ("Sign in Error with existing account")
                            print (error)
                        }
                    }
                }
            } label: {
                Text (signUpFlag == false ? "Sign In With Email" : "Sign Up With Email")
                    .font(.headline)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.white)
                    .background(.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            }
            
            HStack {
                Spacer()
                Button {
                    signUpFlag.toggle()
                } label: {
                    Text (signUpFlag == false ? "Haven't got an account - Register Here" : "Already have an account - click here")
                        .font(.headline)
                        .frame(height: 55)
                }
                Spacer()
            }
            Spacer()
        }
        .errorAlert(error: $error)
        .padding()
        .navigationTitle(signUpFlag == false ? "Sign In With Email" : "Sign Up With Email")
    }
    
    
    func signIntoAuthenticationServer() async throws {
        // User is Attempting to signup for the first time
        if signUpFlag == true {
            if email.isEmpty {
                print ("Email Not Entered")
                self.error = AuthenticationError.emailEmpty
                throw MyError.runtimeError("Email has not been entered")
            }
            
            if !email.isValidEmail {
                print ("Email failed Validation")
                self.error = AuthenticationError.emailFailedValidation
                throw MyError.runtimeError("Email is not in a valid format")
            }
            
            if password.isEmpty && passwordConfirmation.isEmpty {
                print ("Both passwords are empty")
                self.error = AuthenticationError.passwordsBothAreEmpty
                throw MyError.runtimeError("Both passwords do not match")
            }
            
            if password.isEmpty || password != passwordConfirmation {
                print ("Passwords do not match")
                self.error = AuthenticationError.passwordsDoNotMatch
                throw MyError.runtimeError("Passwords do not match")
            }
            
            let returnedUserData = try await AuthenticationManager.shared.createUser(email: email, password: password)
            print ("Success")
            print (returnedUserData)
        } else {
            // The user is telling us they have an account - lets check it out
            guard !email.isEmpty else {
                print ("Email Not Entered")
                self.error = AuthenticationError.emailEmpty
                throw MyError.runtimeError("Email has not been entered")
            }
            
            if !email.isValidEmail {
                print ("Email failed Validation")
                self.error = AuthenticationError.emailFailedValidation
                throw MyError.runtimeError("Email is not in a valid format")
            }
            
            guard !password.isEmpty else {
                print ("Password is empty")
                self.error = AuthenticationError.passwordEmpty
                throw MyError.runtimeError("Password is empty")
            }
            
            let returnedUserData = try await AuthenticationManager.shared.signInUser(email: email, password: password)
            print ("Success")
            print (returnedUserData)
        }
    }
    
    
   
}

#Preview {
    NavigationStack {
        SignInEmailView(showSignInView: .constant(false))
    }
}
