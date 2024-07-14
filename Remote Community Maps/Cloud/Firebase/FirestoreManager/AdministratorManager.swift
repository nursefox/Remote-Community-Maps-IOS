//
//  Administrator.swift
//  Remote Community Maps
//
//  Created by Benjamin Fox on 27/6/2024.
//

import FirebaseAuth
import FirebaseFirestore
import Foundation


class AdministratorManager: ObservableObject {
    
    
    
    @Published private(set) var adminUser: AdminUser? = nil
    @Published var isAdmin:Bool = false
    
    static let shared = AdministratorManager()
    
    private var authStateListener: AuthStateDidChangeListenerHandle?
    private let adminCollection = Firestore.firestore().collection("admins")
    
    init() {
        self.listenForAuthChanges()
    }
    
    deinit {
        if let handle = authStateListener {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    private func adminDocument(userId: String) -> DocumentReference {
        adminCollection.document(userId)
    }

    

    private func listenForAuthChanges() {
        authStateListener = Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            self?.checkAdminStatus(user: user)
        }
    }
    
    
    
    private func checkAdminStatus(user: User?) {
        guard let user = user else {
            self.isAdmin = false
            return
        }
        
        let adminRef = adminCollection.document(user.uid)
        adminRef.getDocument { [weak self] (document, error) in
            if let document = document, document.exists {
                self?.isAdmin = true
            } else {
                self?.isAdmin = false
            }
        }
    }
    
    
    func checkAdminStatus() {
        guard let user = Auth.auth().currentUser else {
            return
        }
        
//        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
//        let adminUser = try await getAdminUser(userId: authDataResult.uid)
        
        let adminRef = adminCollection.document(user.uid)
        
        //let adminRef = db.collection("admins").document(user.uid)
        adminRef.getDocument { (document, error) in
            if let document = document, document.exists {
                self.isAdmin = true
            } else {
                self.isAdmin = false
            }
        }
    }
    
    
    func loadAdminUser() async throws {
        Task {
            print ("AdministratorManager() : loadAdminUser ()")
            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
            let adminUser = try await getAdminUser(userId: authDataResult.uid)
            print ("AdministratorManager() : loadAdminUser () : " + (adminUser.name ?? "No Name Specified"))
            self.isAdmin = true
            self.adminUser = adminUser
            print ("AdministratorManager() : loadAdminUser () : Set to True")
        }
        
        
    }
    
    
//    func isAdminUserFunc () async throws -> Bool {
//        print ("AdministratorManager() : isAdminUserFunc ()")
//        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
//        let adminUser = try await getAdminUser(userId: authDataResult.uid)
//        print ("AdministratorManager() : isAdminUserFunc () : " + (adminUser.name ?? "No Name Specified"))
//        return true
//    }
    
    func getAdminUser(userId: String) async throws -> AdminUser {
        try await adminDocument(userId: userId).getDocument(as: AdminUser.self)
    }
    
    private func getAllAdminUsers() async throws -> [AdminUser] {
        try await adminCollection.getDocuments(as: AdminUser.self)
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


struct AdminUser: Identifiable, Codable {
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
