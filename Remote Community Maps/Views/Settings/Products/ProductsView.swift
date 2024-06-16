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
    @Published var selectedFilter: FilterOption? = nil
    @Published var selectedCategory: CategoryOption? = nil
    
//    func getAllProducts() async throws {
//        self.products = try await ProductsManager.shared.getAllProducts()
//    }
    
    enum FilterOption: String, CaseIterable {
        case noFilter
        case priceHigh
        case priceLow

        var priceDescending: Bool? {
            switch self {
            case .noFilter: return nil
            case .priceHigh: return true
            case .priceLow: return false
            }
        }

    }
    
    func filterSelected (option: FilterOption) async throws {
//        switch option {
//        case .noFilter:
//            self.products = try await ProductsManager.shared.getAllProducts()
//        case .priceHigh:
//            self.products = try await ProductsManager.shared.getAllProductsSortedByPrice(descending: true)
//        case .priceLow:
//            self.products = try await ProductsManager.shared.getAllProductsSortedByPrice(descending: false)
//        }
        
        
        self.selectedFilter = option
        self.getProducts()
    }
    
    
    enum CategoryOption: String, CaseIterable {
        case noCategory
        case smartphones
        case laptops
        case fragrances
        case beauty
        case groceries
        
        var categoryKey: String? {
            if self == .noCategory {
                return nil
            }
            return self.rawValue
        }
    }
    
    func categorySelected (option: CategoryOption) async throws {
//        switch option {
//        case .noCategory:
//            self.products = try await ProductsManager.shared.getAllProducts()
//        case .smartphones, .laptops, .fragrances, .groceries, .beauty:
//            self.products = try await ProductsManager.shared.getAllProductsForCategory(category: option.rawValue)
//        }
    
        
        self.selectedCategory = option
        self.getProducts()
    }
    
    func getProducts() {
        Task {
            self.products = try await ProductsManager.shared.getAllProducts(priceDescending: selectedFilter?.priceDescending, forCategory: selectedCategory?.categoryKey)
        }
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
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarLeading) {
                Menu ("Filter: \(viewModel.selectedFilter?.rawValue ?? "NONE")") {
                    ForEach (ProductsViewModel.FilterOption.allCases, id: \.self) { option in
                        Button (option.rawValue) {
                            Task {
                                try? await viewModel.filterSelected(option: option)
                            }
                        }
                    }
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu ("Filter: \(viewModel.selectedCategory?.rawValue ?? "NONE")") {
                    ForEach (ProductsViewModel.CategoryOption.allCases, id: \.self) { option in
                        Button (option.rawValue) {
                            Task {
                                try? await viewModel.categorySelected(option: option)
                            }
                        }
                    }
                }
            }
        })
        .onAppear {
            viewModel.getProducts()
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
