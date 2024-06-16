//
//  ProductCellView.swift
//  Remote Community Maps
//
//  Created by Benjamin Fox on 16/6/2024.
//

import SwiftUI

struct ProductCellView: View {
    
    let product: Product
    
    var body: some View {
        HStack (alignment: .top, spacing: 12) {
            AsyncImage (url: URL(string: product.thumbnail ?? "")) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 75, height: 75)
                    .cornerRadius(10)
            } placeholder: {
                ProgressView()
            }
            .frame(width: 75, height: 75)
            //.shadow(radius: 10)
            .shadow(color: Color.black.opacity(0.3), radius: 4, x:0, y:2)

            VStack (alignment: .leading, spacing: 8) {
                Text (product.title ?? "n/a")
                    .font(.headline)
                    .foregroundStyle(.primary)
                Text ("Price: $" + String(product.price ?? 0))
                Text ("Rating: " + String(product.rating ?? 0))
                Text ("Brand: " + (product.brand ?? "n/a"))
            }
            .font(.callout)
            .foregroundColor(.secondary)
            
        }    }
}

#Preview {
    ProductCellView(product: Product(id: 1, title: "Test", description: "test", price: 32, discountPercentage: 13, rating: 4, stock: 10, brand: "Apple", category: "Nothing", thumbnail: "Test", images: []))
}
