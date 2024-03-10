//
//  AuthService.swift
//  Remote Community Maps
//
//  Created by Benjamin Fox on 21/2/2024.
//

import Foundation
import FirebaseCore
import FirebaseAuth

struct AuthDataResultModel {
    let uid: String
    let email: String?
    let photoUrl: String?
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
        self.photoUrl = user.photoURL?.absoluteString
    }
}




class AuthenticationManager: ObservableObject {
    
    static let shared: AuthenticationManager = AuthenticationManager()
    
    @Published var signedIn:Bool = false
    
    init() {
        Auth.auth().addStateDidChangeListener() { auth, user in
            if user != nil {
                self.signedIn = true
                print("Auth state changed, is signed in")
            } else {
                self.signedIn = false
                print("Auth state changed, is signed out")
            }
        }
    }
    
    
    func getProvider() throws {
        guard let providerData = Auth.auth().currentUser?.providerData else {
            throw URLError(.badServerResponse)
        }
        
        for provider in providerData {
            print (provider.providerID)
        }
    }
    
    
    func getSignedInUser () throws -> AuthDataResultModel {
        let user = Auth.auth().currentUser
        if let user = user {
            // The user's ID, unique to the Firebase project.
            // Do NOT use this value to authenticate with your backend server,
            // if you have one. Use getTokenWithCompletion:completion: instead.
            let result = AuthDataResultModel(user: user)
            
            //            let uid = user.uid
            //            let email = user.email
            //            let photoURL = user.photoURL
            //            var multiFactorString = "MultiFactor: "
            //            for info in user.multiFactor.enrolledFactors {
            //                multiFactorString += info.displayName ?? "[DispayName]"
            //                multiFactorString += " "
            return result
        }
        throw ("User Not Found")
    }
    
 
    
    
    func getAuthenticatedUser() throws -> AuthDataResultModel {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        return AuthDataResultModel(user: user)
    }
    
    
    
    // Regular password acount sign out.
    // Closure has whether sign out was successful or not
    func regularSignOut(completion: @escaping (Error?) -> Void) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            completion(nil)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
            completion(signOutError)
        }
    }
    
}




// MARK: SIGN IN EMAIL
extension AuthenticationManager {
    
    //MARK: - Traditional sign in
    // Traditional sign in with password and email
    func regularSignIn(email:String, password:String, completion: @escaping (Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) {  authResult, error in
            if let e = error {
                completion(e)
            } else {
                print("Login success")
                completion(nil)
            }
        }
    }
    
    // MARK: - Password Account
    func regularCreateAccount(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let e = error {
                print(e.localizedDescription)
                
            } else {
                print("Successfully created password account")
            }
        }
    }
    
    func createUser(email: String, password: String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    func signUpUser(email: String, password: String) async throws -> AuthDataResultModel {
        
        do {
            let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
            return AuthDataResultModel(user: authDataResult.user)
        } catch {
            throw (error)
        }
    }
    
    
    
    
    
    
    
    func signInUser(email: String, password: String) async throws -> AuthDataResultModel {
        do {
            let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
            return AuthDataResultModel(user: authDataResult.user)
        } catch {
            let err = error as NSError
            if let authErrorCode = AuthErrorCode.Code(rawValue: err.code) {
                switch authErrorCode {
                case .accountExistsWithDifferentCredential:
                    throw MyError.runtimeError("Account already exist with different credential")
                case .credentialAlreadyInUse:
                    throw MyError.runtimeError("Credential is already in use")
                case .unverifiedEmail:
                    throw MyError.runtimeError("An email link was sent to your account, please verify it before logging in")
                case .userDisabled:
                    throw MyError.runtimeError("User is currently disabled")
                case .userNotFound:
                    throw MyError.runtimeError("Cannot find the user, try with different credential")
                case .weakPassword:
                    throw MyError.runtimeError("Password is too weak")
                case .networkError:
                    throw MyError.runtimeError("Error in network connection")
                case .wrongPassword:
                    throw MyError.runtimeError("Password is incorect")
                case .invalidEmail:
                    throw MyError.runtimeError("Email is not valid")
                default:
                    throw MyError.runtimeError("unknown error: \(err.localizedDescription)")
                }
            }
        }
        throw ("Unknown Error")
    }
    
    func resetPassword (email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    
    func signOut () throws {
        try Auth.auth().signOut()
    }
    
    enum AuthenticationError: LocalizedError {
        case emailEmpty
        case emailFailedValidation
        case passwordEmpty
        case passwordsBothAreEmpty
        case passwordsDoNotMatch
        
        var errorDescription: String? {
            switch self {
            case .emailEmpty:
                return "Error"
            case .emailFailedValidation:
                return "Error"
            case .passwordEmpty:
                return "Error"
            case .passwordsBothAreEmpty:
                return "Error"
            case .passwordsDoNotMatch:
                return "Error"
            }
        }
        
        var recoverySuggestion: String? {
            switch self {
            case .emailEmpty:
                return "Fill in a valid email address"
            case .emailFailedValidation:
                return "Please create a valid email address"
            case .passwordEmpty:
                return "Fill in a password"
            case.passwordsBothAreEmpty:
                return "Fill in both passwords"
            case .passwordsDoNotMatch:
                return "Please ensure both passwords match"
            }
        }
    }
    
}


// MARK: SIGN IN SSO
extension AuthenticationManager {
    
    @discardableResult
    func signInWithGoogle(tokens: GoogleSignInResultModel) async throws -> AuthDataResultModel {
        let credential = GoogleAuthProvider.credential(withIDToken: tokens.idToken, accessToken: tokens.accessToken)

        return try await signIn(credential: credential)
    }
    
    func signIn(credential: AuthCredential) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().signIn(with: credential)
        return AuthDataResultModel(user: authDataResult.user)
    }
    
}
