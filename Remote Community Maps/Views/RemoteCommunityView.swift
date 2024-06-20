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
                    
                    NavigationLink (value: Router.Destination.communityAllLocations(remoteCommunity) ) {
                        Text("Display All Locations")
                    }
                }
                
                Section(header: Text("Advanced")) {
                 
                    
                    
                    
                    
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
                
                Section(header: Text("Firebase")) {
                    NavigationLink (value:
                        Router.Destination.communityRemoteManagement(remoteCommunity) ){
                        Text("Local/Remote Data Management")
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
            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button("Delete Remote Data") {
//                        //do {
//                            print ("Deleting all remote data ...")
////                            try modelContex.delete(model: RemoteCommunity.self)
////                            try modelContex.delete(model: LotInformation.self)
////                        } catch {
////                            print ("Failed to delete data")
////                        }
//                    }
//                }
                
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button(action: {
//                        print ("Saving remote data to Firebase ...")
//                        //showSignInView = true
//                    }, label: {
//                        Image(systemName: "checkmark.circle")
//                    })
//                }
//                
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button(action: {
//                        print ("Saving remote data to Firebase ...")
//                        //showSignInView = true
//                    }, label: {
//                        Image(systemName: "x.circle")
//                    })
//                }
                
                
            }
            .navigationBarTitle(remoteCommunity.name, displayMode: .inline)
        }
    }
    
    func pushToRemoteServer () {
        print ("pushToRemoteServer() : Start")
     
        
        
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
