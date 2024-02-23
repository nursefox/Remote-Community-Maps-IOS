//
//  RemoteCommunitiesListView.swift
//  Remote Community Maps
//
//  Created by Benjamin Fox on 6/1/2024.
//

import SwiftData
import SwiftUI

struct RemoteCommunitiesListView: View {
    
    @Environment (\.modelContext) var modelContext
    
    @Query (sort: [
        SortDescriptor(\RemoteCommunity.name),
    ]) var remoteCommunities: [RemoteCommunity]
    
    var body: some View {
        
          List {
              ForEach (remoteCommunities) { community in
                  
                  NavigationLink (value: Router.Destination.communityHomePageView(community)) {
                      VStack(alignment: .center) {
                          HStack (alignment: .center) {
                              VStack (alignment: .leading) {
                                  Text (community.name)
                                  Text (community.traditionalName ?? "")
                                      .italic()
                                      .foregroundStyle(.gray)
                              }
                              
                              Spacer()
                              Image(community.imageFileName)
                                  .resizable()
                                  .aspectRatio(contentMode: .fill)
                                  .frame(width: 180, height: 100)
                                  .background(.white)
                                  .clipShape(RoundedRectangle(cornerRadius: 15.0))
                                  .shadow(radius: 8)
                          }
                      }
                  }
              }
          }
          .listStyle(.plain)
        
        
//        List {
//            ForEach (remoteCommunities) { community in
//                NavigationLink (value: community) {
//                    VStack (alignment: .leading) {
//                        Text (community.name)
//                            .font (.headline)
//                    }
//                }
//            }
//        }
    }
    
    
    
    
    init(sort: [SortDescriptor<RemoteCommunity>], searchString: String) {
        _remoteCommunities = Query(filter: #Predicate {
            if searchString.isEmpty {
                return true
            } else {
                return ($0.name.localizedStandardContains(searchString))
                //return ($0.communityName.localizedStandardContains(searchString) || $0.lotData.contains { $0.lotName.localizedStandardContains(searchString) })
            }
        }, sort: sort)
    }
    
}

#Preview {
    RemoteCommunitiesListView(sort: [SortDescriptor(\RemoteCommunity.name)], searchString: "")
}
