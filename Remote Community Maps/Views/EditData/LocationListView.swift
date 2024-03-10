//
//  LocationListView.swift
//  Remote Community Maps
//
//  Created by Benjamin Fox on 6/1/2024.
//

import SwiftUI

struct LocationListView: View {
    
    @Environment(\.modelContext) var modelContex
    let remoteCommunity: RemoteCommunity
    
    @State private var lotIdBeingSearched = ""
    @State private var showSearch: Bool = false
    //@FocusState private var houseToFindIsFocused: Bool
    
    
    var sortedLots: [LotInformation] {
        remoteCommunity.lotData.sorted {
            $0.name < $1.name
        }
    }
    
    var body: some View {
        VStack (alignment: .center, spacing: 0) {
            Section(header: Text("Edit Map Data")) {
                List {
                    ForEach(sortedLots) { lotInformation in
                        NavigationLink (value: Router.Destination.lotInfoDetailView(lotInformation) ){
                            Text(lotInformation.name)
                        }
                    }
                }
            }
        }
        .navigationBarTitle(remoteCommunity.name, displayMode: .inline)
        .navigationBarTitleDisplayMode(.inline)
        //.searchable( text: $lotIdBeingSearched, isPresented: $showSearch).focused($houseToFindIsFocused)
        .searchable( text: $lotIdBeingSearched, isPresented: $showSearch)
    }
}

#Preview {
    NavigationStack {
        SingleItemPreview<RemoteCommunity> { community in // set the type
            LocationListView(remoteCommunity: community) // add your view with the item
        }
        .modelContainer(DataController.previewContainer)
    }
    
}
