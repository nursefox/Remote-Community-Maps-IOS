//
//  SignInViewModel.swift
//  Remote Community Maps
//
//  Created by Benjamin Fox on 16/6/2024.
//

import Foundation

@MainActor
final class SignInViewMobel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    
    func signUp() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print ("No Email or password found.")
            return
        }
        
        let authDataResult = try await AuthenticationManager.shared.createUser(email: email, password: password)
        let user = DBUser(auth: authDataResult)
        try await UserManager.shared.createNewUser(user: user)
    }
    
    func signIn() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print ("No Email or Password Found.")
            return
        }
        
        var result = try await AuthenticationManager.shared.signInUser(email: email, password: password)
        print ("User Signed In Via Email: " + result.uid)
    }
    
}
