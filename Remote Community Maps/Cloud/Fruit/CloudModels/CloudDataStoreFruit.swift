//
//  DataStore.swift
//  OracleDataTest
//
//  Created by Benjamin Fox on 14/1/2024.
//

import Combine
import Foundation

class CloudDataStoreFruit: ObservableObject {
    
    @Published var fruits = [SODA.Item<CloudModelFruit>]()
    @Published var isLoading = false
    
    static let shared: CloudDataStoreFruit = CloudDataStoreFruit()
    private var tokens = Set<AnyCancellable>()
    
    init() {
        retrieveAllFruits()
    }
    
    func retrieveAllFruits() {
        guard !isLoading else { return }
        
        isLoading = true
        fruits = []
        
        SODA.documents(collection: "fruit", pageSize: 100)
            .map(\.items)
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.isLoading = false
            } receiveValue: { (records: [SODA.Item<CloudModelFruit>]) in
                self.fruits.append(contentsOf: records)
            }
            .store(in: &tokens)
    }
    
    @MainActor
    func retrieveFruit(with id: String) -> AnyPublisher<CloudModelFruit, Error> {
        SODA.document(id: id, in: "fruit")
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    @MainActor
    func refresh(fruit: SODA.Item<CloudModelFruit>) async -> CloudModelFruit {
        await withUnsafeContinuation { c in
            isLoading = true
            
            self.retrieveFruit(with: fruit.id)
                .assertNoFailure()
                .sink { res in
                    self.modelUpdate(fruit: fruit, with: res)
                    self.isLoading = false
                    
                    c.resume(returning: res)
                }
                .store(in: &tokens)
        }
    }
    
    @MainActor
    func update(fruit: SODA.Item<CloudModelFruit>) async -> SODA.Item<CloudModelFruit> {
        await withUnsafeContinuation { c in
            isLoading = true
            
            SODA.update(id: fruit.id, collection: "fruit", with: fruit.value)
                .assertNoFailure()
                .receive(on: DispatchQueue.main)
                .sink {
                    self.modelUpdate(fruit: fruit, with: fruit.value)
                    self.isLoading = false
                    
                    c.resume(returning: fruit)
                }
                .store(in: &tokens)
        }
    }
    
    @MainActor
    func add(fruit: SODA.Item<CloudModelFruit>) async -> SODA.Item<CloudModelFruit> {
        await withUnsafeContinuation { c in
            isLoading = true
            
            SODA.add(collection: "fruit", with: fruit.value!) // Should force unwrap because SODA.Item.value is really an optional, and we want to pass the right type upstream
                .assertNoFailure()
                .receive(on: DispatchQueue.main)
                .sink { item in
                    self.isLoading = false
                    self.modelAdd(fruit: item)
                    
                    c.resume(returning: item)
                }
                .store(in: &tokens)
        }
    }
    
    @MainActor
    func addOrUpdate(fruit: SODA.Item<CloudModelFruit>) async -> SODA.Item<CloudModelFruit> {
        if fruit.id == "" {
            return await add(fruit: fruit)
        } else {
            return await update(fruit: fruit)
        }
    }
    
    
    // MARK:- Helper functions
    func modelUpdate(fruit: SODA.Item<CloudModelFruit>, with newValue: CloudModelFruit) {
        guard let idx = fruits.firstIndex(where: { $0.id == fruit.id }) else { return }
        fruits[idx].value = newValue
    }
    
    func modelAdd(fruit: SODA.Item<CloudModelFruit>) {
        fruits.append(fruit)
    }
    
    func fruit(with id: String) -> SODA.Item<CloudModelFruit>? {
        fruits.first { $0.id == id }
    }
    
}
