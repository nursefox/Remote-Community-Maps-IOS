//
//  SignInMethodView.swift
//  Remote Community Maps
//
//  Created by Benjamin Fox on 23/2/2024.
//

import SwiftUI
import AuthenticationServices

private enum FocusableField: Hashable {
    case email
    case password
}

struct SignInMethodView: View {
    
    //@FocusState private var focus: FocusableField?
    @State private var email = ""
    @State private var password = ""
    @State private var error: Swift.Error?
    
    //@State private var showSignInView: Bool = false
    
    @Binding var showSignInView: Bool
    
    
    var body: some View {
        
        
        VStack {
            
            Image("Login")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(minHeight: 150, maxHeight: 200)
            
            Text("Login")
                .font(.largeTitle)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Divider()
            
            HStack {
                Image(systemName: "at")
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
                Image(systemName: "lock")
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
                        showSignInView = false
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
            
            Button (action: {}) {
                Image ("Google")
                Text ("Sign in With Google")
                    .foregroundStyle(.black)
                    .font(.headline)
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
            }
            .buttonStyle(.bordered)
            
            Divider()
            
            SignInWithAppleButton { request in
                print ("Signing in")
            } onCompletion: { result in
                print ("Finished Signing in")
            }
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: 45)
            
            //            .cornerRadius(8)
            
            Divider()
            
            
            NavigationLink {
                SignUpViewEmailView(showSignInView: $showSignInView)
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
        .padding()
        //.navigationTitle("Sign In")
    }
    
    
    func signIntoAuthenticationServer() async throws {
        
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


#Preview {
    NavigationStack {
        SignInMethodView(showSignInView: .constant(false))
    }
}
