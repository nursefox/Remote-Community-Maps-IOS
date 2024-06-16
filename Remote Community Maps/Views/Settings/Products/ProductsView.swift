//
//  ProductsView.swift
//  Remote Community Maps
//
//  Created by Benjamin Fox on 16/6/2024.
//

import SwiftUI


@MainActor
final class ProductsViewModel: ObservableObject {
    @Published private(set) var products: [Product] = []
    
    func getAllProducts() async throws {
        self.products = try await ProductsManager.shared.getAllProducts()
    }
    

}

struct ProductsView: View {
    
    @StateObject private var viewModel = ProductsViewModel()
    
    var body: some View {
        List {
            ForEach (viewModel.products) { product in
                ProductCellView(product: product)
            }
        }
        .navigationTitle("Products")
        .task {
            try? await viewModel.getAllProducts()
        }
//        .onAppear {
//            viewModel.downloadProductsAndUploadToFirebase()
//        }
    }
}

#Preview {
    NavigationStack {
        ProductsView()
    }
}
