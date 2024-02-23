//
//  LotInformationEditLotColours.swift
//  Remote Community Maps
//
//  Created by Benjamin Fox on 24/12/2023.
//

import SwiftData
import SwiftUI

struct LotInformationEditLotColours: View {
    
    @Environment(\.modelContext) var modelContex
    @Bindable var remoteCommunity: RemoteCommunity
    //@Bindable var lots: [LotInformation]()
    
    //@Query(sort: \LotInformation.lotName, order: .forward) var lotDataTest: [LotInformation]
    
    //    @Query( sort: [
    //        SortDescriptor(\LotInformation.remoteCommunity?.communityName),
    //        SortDescriptor(\LotInformation.lotName)
    //       ] )
    //    var lotInfoArray: [LotInformation]
    
    //
    //    var remoteCommunities: Array<RemoteCommunity> { Array(Set(lotInfoArray.compactMap{ $0.remoteCommunity })) }
    
    var sortedLots: [LotInformation] {
        remoteCommunity.lotData.sorted {
            $0.name < $1.name
        }
    }
    
    var body: some View {
        
        
        VStack (alignment: .center, spacing: 0) {
            
            Text ("Bulk Edit for House Colour Assignment")
            
            Form {
                
                Section(header: Text("Edit Map Data")) {
                    List {
                        ForEach(sortedLots) { lotInformation in
                            
                            @Bindable var lotInfo = lotInformation
                            
                            HStack (alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/ ) {
                                Text (lotInfo.name)
                                Spacer()
                                TextField ("", text: $lotInfo.colourDescriptor.toUnwrapped(defaultValue: ""))
                                    .multilineTextAlignment(.trailing)
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
            }
            .navigationBarTitle(remoteCommunity.name, displayMode: .inline)
        }
        //.navigationViewStyle(StackNavigationViewStyle())
        
    }
}


#Preview {
    NavigationStack {
        SingleItemPreview<RemoteCommunity> { community in // set the type
            LotInformationEditLotColours(remoteCommunity: community) // add your view with the item
        }
        .modelContainer(DataController.previewContainer)
    }
}
