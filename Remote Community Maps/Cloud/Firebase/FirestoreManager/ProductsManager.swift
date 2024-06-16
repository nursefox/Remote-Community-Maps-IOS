//
//  ProductsManager.swift
//  Remote Community Maps
//
//  Created by Benjamin Fox on 16/6/2024.
//

import FirebaseFirestore
import Foundation

final class ProductsManager {
    
    static let shared = ProductsManager()
    private init() {}
    
    private let productsCollection = Firestore.firestore().collection("products")
    
    private func productDocument(productId: String) -> DocumentReference {
        productsCollection.document(productId)
    }
    
    func uploadProduct(product: Product) async throws {
        try productDocument(productId: String(product.id)).setData(from: product, merge: false)
    }
    
    
    func getAllProducts() async throws -> [Product] {
        try await productsCollection.getDocuments(as: Product.self)
    }
    
    
    func getProduct(productId: String) async throws -> Product {
        try await productDocument(productId: productId).getDocument(as: Product.self)
    }
    
    
    //    func downloadProductsAndUploadToFirebase() {
    //        guard let url = URL(string: "https://dummyjson.com/products") else { return }
    //
    //        Task {
    //            do {
    //                let (data, response) = try await URLSession.shared.data(from: url)
    //                let products = try JSONDecoder().decode(ProductsArray.self, from: data)
    //                let productArray = products.products
    //
    //                for product in productArray {
    //                    try? await ProductsManager.shared.uploadProduct(product: product)
    //                }
    //
    //                print ("SUCCESS")
    //                print (products.products.count)
    //
    //            } catch {
    //                print (error)
    //            }
    //        }
    //    }
    
}

extension Query {
    func getDocuments <T> (as type: T.Type) async throws -> [T] where T : Decodable {
        let snapshot = try await self.getDocuments()
        return try snapshot.documents.map({document in
            try document.data(as: T.self)
        })
    }
}
