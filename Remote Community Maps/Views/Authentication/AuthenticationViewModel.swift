//
//  AuthenticationViewModel.swift
//  Remote Community Maps
//
//  Created by Benjamin Fox on 16/6/2024.
//

import Foundation

@MainActor
final class AuthenticationViewModel: ObservableObject {
    
    func signIntoGoogle() async throws {
        let helper = SignInGoogleHelper()
        let tokens = try await helper.signIn()
        let authDataResult = try await AuthenticationManager.shared.signInWithGoogle(tokens: tokens)
        let user = DBUser(auth: authDataResult)
        try await UserManager.shared.createNewUser(user: user)
    }
    
    func signInApple() async throws {
        let helper = SignInAppleHelper()
        let tokens = try await helper.startSignInWithAppleFlow()
        let authDataResult = try await AuthenticationManager.shared.signInWithApple(tokens: tokens)
        let user = DBUser(auth: authDataResult)
        try await UserManager.shared.createNewUser(user: user)    }
    
    func signIntoEmail() async throws {
        
    }
    
    func signInAnonymous() async throws {
        let authDataResult = try await AuthenticationManager.shared.signInAnonymous()
        let user = DBUser(auth: authDataResult)
        try await UserManager.shared.createNewUser(user: user)
        
     //   try await UserManager.shared.createNewUser(auth: authDataResult)
    }
}
