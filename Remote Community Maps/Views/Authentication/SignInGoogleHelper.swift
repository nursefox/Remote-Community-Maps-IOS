//
//  SignInGoogleHelper.swift
//  Remote Community Maps
//
//  Created by Benjamin Fox on 3/3/2024.
//

import Foundation
import GoogleSignIn
import GoogleSignInSwift

struct GoogleSignInResultModel {
    let idToken: String
    let accessToken: String
}

final class SignInGoogleHelper{
    
    @MainActor
    func signIn() async throws  -> GoogleSignInResultModel {
        
        guard let topVC = Utilities.shared.getTopViewController() else {
            throw URLError (.cannotFindHost)
        }
        
        let gidSignInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: topVC)
        
        guard let idToken: String = gidSignInResult.user.idToken?.tokenString else {
            throw (URLError(.badServerResponse))
        }
        
        let accessToken: String = gidSignInResult.user.accessToken.tokenString
        
        let tokens = GoogleSignInResultModel(idToken: idToken, accessToken: accessToken)
        return tokens
    }
}
