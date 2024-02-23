//
//  DataController.swift
//  Remote Community Maps
//
//  Created by Benjamin Fox on 16/12/2023.
//

import Foundation
import SwiftData

@MainActor
class DataController {
    static let previewContainer: ModelContainer = {
           do {
               let config = ModelConfiguration(isStoredInMemoryOnly: true)
               let container = try ModelContainer(for: RemoteCommunity.self, configurations: config)
               
               print (URL.applicationSupportDirectory.path(percentEncoded: false))
               
               // Load and decode the JSON.
               guard let url = Bundle.main.url(forResource: "Remote-Community-Map-Data", withExtension: "json") else {
                   fatalError("Failed to find Remote-Community-Map-Data.json")
               }
               
               let data = try Data(contentsOf: url)
               let loadedRemoteCommunities = try JSONDecoder().decode([RemoteCommunity].self, from: data)
               
               // Add all our data to the context.
               for remoteCommunity in loadedRemoteCommunities {
                   container.mainContext.insert(remoteCommunity)
                   
                   Bundle.main.decodeGeoJSON( context: container.mainContext, community: remoteCommunity, from: remoteCommunity.mapDataFileName)
                   
                   
//                   let lotInfo = LotInformation(
//                       lotName: "test",
//                       lotDescription: "Somewhere nice",
//                       lotLatitude: 124.55,
//                       lotLongitude: -22.292)
//
//                   lotInfo.remoteCommunity = remoteCommunity
//                   //remoteCommunity.lotData.append(lotInfo)
//                   container.mainContext.insert(lotInfo)
//                   //try? container.mainContext.save()
                   
               }
               
               
               
               
               return container
           } catch {
               fatalError("Failed to create model container for previewing: \(error.localizedDescription)")
           }
       }()
    
    
    static func remoteCommunitySample () -> RemoteCommunity {
        print ("Searching for remote community")
        let tempCommunites = Bundle.main.decode([RemoteCommunity].self, from: "Remote-Community-Map-Data.json")
        return tempCommunites[0]
    }
}
