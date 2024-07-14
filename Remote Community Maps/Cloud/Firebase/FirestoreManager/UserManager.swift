//
//  UserManager.swift
//  Remote Community Maps
//
//  Created by Benjamin Fox on 15/6/2024.
//

import Foundation
import FirebaseFirestore

struct Movie: Codable {
    let id: String
    let title: String
    let isPopular: Bool
}

struct DBUser: Codable {
    let userId: String
    let isAnonymous: Bool?
    let email: String?
    let photoUrl: String?
    let dateCreated: Date?
    let isPremium: Bool?
    let preferences: [String]?
    let favouriteMovie: Movie?
    
    init(auth: AuthDataResultModel) {
        self.userId = auth.uid
        self.isAnonymous = auth.isAnonymous
        self.email = auth.email
        self.photoUrl = auth.photoUrl
        self.dateCreated = Date()
        self.isPremium = false
        self.preferences = nil
        self.favouriteMovie = nil
    }
    
    
    init (userId: String,
          isAnonymous: Bool? = nil,
          email: String? = nil,
          photoUrl: String? = nil,
          dateCreated: Date? = nil,
          isPremium: Bool? = nil,
          preferences: [String]? = nil,
          favouriteMovie: Movie? = nil
    ) {
        self.userId = userId
        self.isAnonymous = isAnonymous
        self.email = email
        self.photoUrl = photoUrl
        self.dateCreated = dateCreated
        self.isPremium = isPremium
        self.preferences = preferences
        self.favouriteMovie = favouriteMovie
    }
    
    //    mutating func togglePremiumStatus() {
    //        let currentValue = isPremium ?? false
    //        isPremium = !currentValue
    //    }
    
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case isAnonymous = "is_anonymous"
        case email = "email"
        case photoUrl = "photo_url"
        case dateCreated = "date_created"
        case isPremium = "user_isPremium"
        case preferences = "preferences"
        case favouriteMovie = "favourite_movie"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.isAnonymous = try container.decodeIfPresent(Bool.self, forKey: .isAnonymous)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.photoUrl = try container.decodeIfPresent(String.self, forKey: .photoUrl)
        self.dateCreated = try container.decodeIfPresent(Date.self, forKey: .dateCreated)
        self.isPremium = try container.decodeIfPresent(Bool.self, forKey: .isPremium)
        self.preferences = try container.decodeIfPresent([String].self, forKey: .preferences)
        self.favouriteMovie = try container.decodeIfPresent(Movie.self, forKey: .favouriteMovie)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.userId, forKey: .userId)
        try container.encodeIfPresent(self.isAnonymous, forKey: .isAnonymous)
        try container.encodeIfPresent(self.email, forKey: .email)
        try container.encodeIfPresent(self.photoUrl, forKey: .photoUrl)
        try container.encodeIfPresent(self.dateCreated, forKey: .dateCreated)
        try container.encodeIfPresent(self.isPremium, forKey: .isPremium)
        try container.encodeIfPresent(self.preferences, forKey: .preferences)
        try container.encodeIfPresent(self.favouriteMovie, forKey: .favouriteMovie)
    }
}

final class UserManager {
    
    static let shared = UserManager()
    private init() {}
    
    private let userCollection = Firestore.firestore().collection("users")
    private func userDocument(userId: String) -> DocumentReference {
        userCollection.document(userId)
    }
    
    private let encoder: Firestore.Encoder = {
        let encoder = Firestore.Encoder()
        return encoder
    }()

    private let decoder: Firestore.Decoder = {
        let decoder = Firestore.Decoder()
        return decoder
    }()
    
    func createNewUser(user: DBUser) async throws {
        try userDocument(userId: user.userId).setData(from: user, merge: false)
    }
    
    func getUser(userId: String) async throws -> DBUser {
        try await userDocument(userId: userId).getDocument(as: DBUser.self)
    }
    
    func updateUserPremiumStatus(userId: String, isPremium: Bool) async throws {
        let data: [String: Any] = [DBUser.CodingKeys.isPremium.rawValue : isPremium]
        try await userDocument(userId: userId).updateData(data)
    }
    
    
    func addUserPreference(userId: String, preference: String) async throws {
        let data: [String: Any] = [DBUser.CodingKeys.preferences.rawValue : FieldValue.arrayUnion([preference])]
        try await userDocument(userId: userId).updateData(data)
    }
    
    func removeUserPreference(userId: String, preference: String) async throws {
        let data: [String: Any] = [DBUser.CodingKeys.preferences.rawValue : FieldValue.arrayRemove([preference])]
        try await userDocument(userId: userId).updateData(data)
    }
    
    func addFavouriteMovie(userId: String, movie: Movie) async throws {
        guard let data = try? encoder.encode (movie) else {
            throw URLError (.badURL)
        }
        
        let dict: [String: Any] = [DBUser.CodingKeys.favouriteMovie.rawValue : data]
        try await userDocument(userId: userId).updateData(dict)
    }
    
    func removeFavouriteMovie(userId: String) async throws {
        let data: [String: Any?] = [DBUser.CodingKeys.favouriteMovie.rawValue : nil]
        try await userDocument(userId: userId).updateData(data as [AnyHashable : Any])
    }
}
