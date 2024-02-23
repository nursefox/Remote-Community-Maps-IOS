//
//  CloudDataStoreRemoteCommunity.swift
//  Remote Community Maps
//
//  Created by Benjamin Fox on 17/1/2024.
//

import Combine
import Foundation

class CloudDataStoreRemoteCommunity: ObservableObject {
    
    @Published var remoteCommunities = [SODA.Item<CloudModelRemoteCommunity>]()
    @Published var isLoading = false
    
    static let shared: CloudDataStoreRemoteCommunity = CloudDataStoreRemoteCommunity()
    private var tokens = Set<AnyCancellable>()
    
    init() {
        retrieveAllCommunities()
    }
    
    func retrieveAllCommunities() {
        guard !isLoading else { return }
        
        isLoading = true
        remoteCommunities = []
        
        SODA.documents(collection: "remoteCommunities", pageSize: 100)
            .map(\.items)
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.isLoading = false
            } receiveValue: { (records: [SODA.Item<CloudModelRemoteCommunity>]) in
                self.remoteCommunities.append(contentsOf: records)
            }
            .store(in: &tokens)
    }
    
    
    @MainActor
    func retrieveRemoteCommunity(with id: String) -> AnyPublisher<CloudModelRemoteCommunity, Error> {
        SODA.document(id: id, in: "remoteCommunities")
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    @MainActor
    func refresh(remoteCommunity: SODA.Item<CloudModelRemoteCommunity>) async -> CloudModelRemoteCommunity {
        await withUnsafeContinuation { c in
            isLoading = true
            
            self.retrieveRemoteCommunity(with: remoteCommunity.id)
                .assertNoFailure()
                .sink { res in
                    self.modelUpdate(remoteCommunity: remoteCommunity, with: res)
                    self.isLoading = false
                    
                    c.resume(returning: res)
                }
                .store(in: &tokens)
        }
    }
    
    @MainActor
    func update(remoteCommunity: SODA.Item<CloudModelRemoteCommunity>) async -> SODA.Item<CloudModelRemoteCommunity> {
        await withUnsafeContinuation { c in
            isLoading = true
            
            SODA.update(id: remoteCommunity.id, collection: "remoteCommunities", with: remoteCommunity.value)
                .assertNoFailure()
                .receive(on: DispatchQueue.main)
                .sink {
                    self.modelUpdate(remoteCommunity: remoteCommunity, with: remoteCommunity.value)
                    self.isLoading = false
                    
                    c.resume(returning: remoteCommunity)
                }
                .store(in: &tokens)
        }
    }
    
    @MainActor
    func add(remoteCommunity: SODA.Item<CloudModelRemoteCommunity>) async -> SODA.Item<CloudModelRemoteCommunity> {
        await withUnsafeContinuation { c in
            isLoading = true
            
            SODA.add(collection: "remoteCommunities", with: remoteCommunity.value!) // Should force unwrap because SODA.Item.value is really an optional, and we want to pass the right type upstream
                .assertNoFailure()
                .receive(on: DispatchQueue.main)
                .sink { item in
                    self.isLoading = false
                    self.modelAdd(remoteCommunity: item)
                    
                    c.resume(returning: item)
                }
                .store(in: &tokens)
        }
    }
    
    @MainActor
    func addOrUpdate(remoteCommunity: SODA.Item<CloudModelRemoteCommunity>) async -> SODA.Item<CloudModelRemoteCommunity> {
        if remoteCommunity.id == "" {
            return await add(remoteCommunity: remoteCommunity)
        } else {
            return await update(remoteCommunity: remoteCommunity)
        }
    }
    
    
    // MARK:- Helper functions
    func modelUpdate(remoteCommunity: SODA.Item<CloudModelRemoteCommunity>, with newValue: CloudModelRemoteCommunity) {
        guard let idx = remoteCommunities.firstIndex(where: { $0.id == remoteCommunity.id }) else { return }
        remoteCommunities[idx].value = newValue
    }
    
    func modelAdd(remoteCommunity: SODA.Item<CloudModelRemoteCommunity>) {
        remoteCommunities.append(remoteCommunity)
    }
    
    func remoteCommunity(with id: String) -> SODA.Item<CloudModelRemoteCommunity>? {
        remoteCommunities.first { $0.id == id }
    }
    
}
