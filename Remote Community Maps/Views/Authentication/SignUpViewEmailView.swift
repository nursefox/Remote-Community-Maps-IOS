//
//  SignUpViewEmailView.swift
//  Remote Community Maps
//
//  Created by Benjamin Fox on 23/2/2024.
//

import SwiftUI

private enum FocusableField: Hashable {
    case email
    case password
    case confirmPassword
}

struct SignUpViewEmailView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var passwordConfirmation = ""
    
    @FocusState private var focus: FocusableField?

    
    @State private var error: Swift.Error?
    
    @Binding var showSignInView: Bool
    
    var body: some View {
        VStack {
            
            
            Image("SignUp")
              .resizable()
              .aspectRatio(contentMode: .fit)
              .frame(minHeight: 150, maxHeight: 200)
            
            Text("Sign up")
              .font(.largeTitle)
              .fontWeight(.bold)
              .frame(maxWidth: .infinity, alignment: .leading)
            
            
            HStack {
              Image(systemName: "at")
              TextField("Email", text: $email)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                //.focused($focus, equals: .email)
                .submitLabel(.next)
                .onSubmit {
                  self.focus = .password
                }
            }
            .padding(.vertical, 6)
            .background(Divider(), alignment: .bottom)
            .padding(.bottom, 4)
            
            
            
            HStack {
              Image(systemName: "lock")
              SecureField("Password", text: $password)
                //.focused($focus, equals: .password)
                .submitLabel(.next)
                .onSubmit {
                  self.focus = .confirmPassword
                }
            }
            .padding(.vertical, 6)
            .background(Divider(), alignment: .bottom)
            .padding(.bottom, 8)
            
            HStack {
              Image(systemName: "lock")
              SecureField("Confirm password", text: $passwordConfirmation)
                .focused($focus, equals: .confirmPassword)
//                .submitLabel(.go)
//                .onSubmit {
//                  print ("checking")
//                }
            }
            .padding(.vertical, 6)
            .background(Divider(), alignment: .bottom)
            .padding(.bottom, 8)
            
            
            
            
            
//            
//            TextField ("Email ...", text: $email)
//                .textCase(.lowercase)
//                .autocapitalization(.none)
//                .padding()
//                .background(Color.gray.opacity(0.1))
//                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
//            
//            TextField ("Password ...", text: $password)
//                .padding()
//                .background(Color.gray.opacity(0.1))
//                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
//            
//            
//            TextField ("Confirm Password ...", text: $passwordConfirmation)
//                .padding()
//                .background(Color.gray.opacity(0.1))
//                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        
            
            Button {
                Task {
                    
                    
                    // Sign Up - Create a new account
                    do {
                        try await signIntoAuthenticationServer()
                        showSignInView = false
                    } catch {
                        print ("Sign in Error with attempting to create new account")
                        print (error)
                    }
                    
                }
            } label: {
                Text ("Sign Up With Email")
                    .font(.headline)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.white)
                    .background(.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            }
            
            
            Spacer()
        }
        .errorAlert(error: $error)
        .padding()
        //.navigationTitle("Sign Up With Email")
    }
    
    
    func signIntoAuthenticationServer() async throws {
        // User is Attempting to signup for the first time
        
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
    }
}

#Preview {
    NavigationStack {
        SignUpViewEmailView(showSignInView: .constant(false))
    }
}
