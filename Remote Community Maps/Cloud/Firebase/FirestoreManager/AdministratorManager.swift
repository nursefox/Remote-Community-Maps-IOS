//
//  Administrator.swift
//  Remote Community Maps
//
//  Created by Benjamin Fox on 27/6/2024.
//

import FirebaseFirestore
import Foundation

final class AdministratorManager {
    
    static let shared = AdministratorManager()
    private init() {}
    
    private let adminCollection = Firestore.firestore().collection("admins")
    
    private func adminDocument(userId: String) -> DocumentReference {
        adminCollection.document(userId)
    }
    
    private func getAllProducts() async throws -> [Administrator] {
        try await adminCollection.getDocuments(as: Administrator.self)
    }
    
    private let encoder: Firestore.Encoder = {
        let encoder = Firestore.Encoder()
        return encoder
    }()

    private let decoder: Firestore.Decoder = {
        let decoder = Firestore.Decoder()
        return decoder
    }()
}


struct Administrator: Identifiable, Codable {
    let id: String
    let name: String?
    let email: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case email
    }
    
    init (id: String,
          name: String? = nil,
          email: String? = nil
    ) {
        self.id = id
        self.name = name
        self.email = email
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encodeIfPresent(self.name, forKey: .name)
        try container.encodeIfPresent(self.email, forKey: .email)
    }
}
