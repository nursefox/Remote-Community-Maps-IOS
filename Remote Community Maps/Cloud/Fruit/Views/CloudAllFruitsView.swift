//
//  AllFruitsView.swift
//  Remote Community Maps
//
//  Created by Benjamin Fox on 16/1/2024.
//

import SwiftUI

struct CloudAllFruitsView: View {
    
    @EnvironmentObject private var dataStore: CloudDataStoreFruit
    
    var body: some View {
        NavigationView {
            List(dataStore.fruits) { fruit in
                NavigationLink(destination: CloudFruitDetailView(fruit: fruit).environmentObject(self.dataStore) ) {
                    fruitRow(fruit)
                }
            }
            .navigationBarTitle("Fruits")
            .listStyle(.plain)
            .refreshable { dataStore.retrieveAllFruits() }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: CloudFruitDetailView(fruit: nil).environmentObject(self.dataStore)) {
                        Image(systemName: "plus")
                    }
                    .disabled(dataStore.isLoading)
                }
                 
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: dataStore.retrieveAllFruits) {
                        Label("Refresh", systemImage: "arrow.clockwise")
                    }
                    .disabled(dataStore.isLoading)
                    
                }
            }
        }
        .environmentObject(dataStore)
        .task {
            dataStore.retrieveAllFruits()
        }
    }
    
    private func fruitRow(_ fruit: SODA.Item<CloudModelFruit>) -> some View {
        Text("\(fruit.value.count)") +
        Text(" \(fruit.value.colour ?? "colorless")") +
        Text(" \(fruit.value.name)s").font(Font.body.bold())
    }
}

#Preview {
    CloudAllFruitsView()
        .environmentObject(CloudDataStoreFruit())
}
