//
//  ProfileViewModel.swift
//  Remote Community Maps
//
//  Created by Benjamin Fox on 16/6/2024.
//

import Foundation

@MainActor
final class UserProfileViewModel: ObservableObject {
    
    @Published private(set) var user: DBUser? = nil
    
    func loadCurrentUser() async throws {
        print ("UserProfileViewModel() : loadCurrentUser ()")
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        print ("UserProfileViewModel() : loadCurrentUser () : \(authDataResult.uid)")
        self.user = try await UserManager.shared.getUser(userId: authDataResult.uid)
        //print (self.user)
    }
    
    func togglePremiumStatus () {
        
        guard let user else { return }
        let currentValue = user.isPremium ?? false
        
        Task {
            try await UserManager.shared.updateUserPremiumStatus(userId: user.userId, isPremium: !currentValue)
            self.user = try await UserManager.shared.getUser(userId: user.userId)
        }
    }
    
    func addUserPreferences(text: String) {
        guard let user else { return }
        
        Task {
            try await UserManager.shared.addUserPreference(userId: user.userId,  preference: text)
            self.user = try await UserManager.shared.getUser(userId: user.userId)
        }
    }
    
    
    func removeUserPreferences(text: String) {
        guard let user else { return }
        
        
        
        Task {
            try await UserManager.shared.removeUserPreference(userId: user.userId,  preference: text)
            self.user = try await UserManager.shared.getUser(userId: user.userId)
        }
    }
    
    
    func addFavouriteMovie() {
        guard let user else { return }
        
        let movie = Movie (id: "1", title: "Avatar 2" , isPopular: true )
        
        Task {
            try await UserManager.shared.addFavouriteMovie(userId: user.userId , movie: movie)
            self.user = try await UserManager.shared.getUser(userId: user.userId)
        }
    }
    
    
    func removeFavouriteMovie() {
        guard let user else { return }
        

        Task {
            try await UserManager.shared.removeFavouriteMovie(userId: user.userId)
            self.user = try await UserManager.shared.getUser(userId: user.userId)
        }
    }
    
    
}
