//
//  RemoteCommunityView.swift
//  Remote Community Maps
//
//  Created by Benjamin Fox on 17/12/2023.
//

import SwiftData
import SwiftUI

struct RemoteCommunityView: View {
    
    @Environment(\.modelContext) var modelContex
    let remoteCommunity: RemoteCommunity
    
    var sortedLots: [LotInformation] {
        remoteCommunity.lotData.sorted {
            $0.name < $1.name
        }
    }
    
    var body: some View {
        
        VStack (alignment: .center, spacing: 0) {
            
            VStack(alignment: .center, spacing: 16.0) {
                Image(remoteCommunity.imageFileName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 150)
            }
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10.0))
            .shadow(radius: 8)
            .padding(.bottom, 16)
            
            Form {
                Section(header: Text("Search")) {
                    NavigationLink (value: Router.Destination.communitySearchView(remoteCommunity) ) {
                        Text("Display Map")
                    }
                    .bold()
                    .foregroundColor(.blue)
                }
                
                Section(header: Text("Advanced")) {
                 
                    NavigationLink (value: Router.Destination.communityAllLocations(remoteCommunity) ) {
                        Text("Display All Locations")
                    }
                    
                    
                    
                    NavigationLink (value: Router.Destination.communityAddPointOfInterest(remoteCommunity) ){
                        Text("Add a Missing Place")
                    }
                    
                
                }
                
                Section(header: Text("Admin")) {
                    NavigationLink (value: Router.Destination.communityEditColours(remoteCommunity) ){
                        Text("Assign Colours to Locations")
                    }
                    
                    NavigationLink (value: Router.Destination.communityListOfLocations(remoteCommunity) ){
                        Text("Update Details of Existing Location")
                    }
                    
                }
                
                
//                Section(header: Text("Edit Map Data")) {
//                    List {
//                        ForEach(sortedLots) { lotInformation in
//                            
//                            NavigationLink (value: Router.Destination.lotInfoDetailView(lotInformation) ){
//                                Text(lotInformation.lotName)
//                            }
//                        }
//                    }
//                }
            }
            .navigationBarTitle(remoteCommunity.name, displayMode: .inline)
        }
    }
}

#Preview {
    NavigationStack {
        SingleItemPreview<RemoteCommunity> { community in // set the type
            RemoteCommunityView(remoteCommunity: community) // add your view with the item
        }
        .modelContainer(DataController.previewContainer)
    }
}
