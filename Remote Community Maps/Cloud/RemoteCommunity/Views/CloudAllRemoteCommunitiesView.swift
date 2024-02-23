//
//  AllRemoteCommunitiesCloudView.swift
//  Remote Community Maps
//
//  Created by Benjamin Fox on 17/1/2024.
//

import SwiftUI

struct CloudAllRemoteCommunitiesView: View {
    
    @EnvironmentObject private var dataStore: CloudDataStoreRemoteCommunity
    
    var body: some View {
        NavigationView {
            List(dataStore.remoteCommunities) { remoteCommunity in
                NavigationLink(destination: CloudRemoteCommunityDetailView(remoteCommunity: remoteCommunity).environmentObject(self.dataStore) ) {
                    remoteCommunityRow(remoteCommunity)
                }
            }
            
            .navigationBarTitle("Remote Communities (Cloud)", displayMode: .inline)
            .listStyle(.plain)
            .refreshable { dataStore.retrieveAllCommunities() }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: CloudRemoteCommunityDetailView(remoteCommunity: nil).environmentObject(self.dataStore)) {
                        Image(systemName: "plus")

                    }
                    .disabled(dataStore.isLoading)
                }
                 
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: dataStore.retrieveAllCommunities) {
                        Label("Refresh", systemImage: "arrow.clockwise")
                    }
                    .disabled(dataStore.isLoading)
                    
                }
            }
        }
        .environmentObject(dataStore)
        .task {
            dataStore.retrieveAllCommunities()
        }
    }
    
    private func remoteCommunityRow(_ remoteCommunity: SODA.Item<CloudModelRemoteCommunity>) -> some View {
        Text("\(remoteCommunity.value.name)")
    }
}

#Preview {
    CloudAllRemoteCommunitiesView()
        .environmentObject(CloudDataStoreRemoteCommunity())
}
