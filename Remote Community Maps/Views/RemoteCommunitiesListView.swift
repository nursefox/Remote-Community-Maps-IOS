//
//  RemoteCommunitiesListView.swift
//  Remote Community Maps
//
//  Created by Benjamin Fox on 6/1/2024.
//

import MapKit
import SwiftData
import SwiftUI

struct RemoteCommunitiesListView: View {
    
    @EnvironmentObject var locationManager: LocationManager
    @Environment (\.modelContext) var modelContext
    
    @State private var cameraPosition: MapCameraPosition = .automatic
    @State private var mapSelection: MKMapItem?
    @State private var selectedTag: String?

    @State private var selectedRemoteCommunity: RemoteCommunity?
    @State var isPresenting = false

    @Query(sort: [SortDescriptor(\RemoteCommunity.state), SortDescriptor(\RemoteCommunity.name)])
    var remoteCommunities: [RemoteCommunity]
    
    @State private var sortType = "distance"
    
    var sortedLocations: [RemoteCommunity] {
        guard let currentLocation = locationManager.currentLocation else {
            return remoteCommunities
        }
        
        return remoteCommunities.sorted { location1, location2 in
            let distance1 = location1.distance(from: currentLocation) ?? Double.infinity
            let distance2 = location2.distance(from: currentLocation) ?? Double.infinity
            return distance1 < distance2
        }
    }
    
    var body: some View {
        if (sortType == "state") {
            let groupedCommunities = Dictionary(grouping: remoteCommunities, by: { $0.state })
            List {
                ForEach(groupedCommunities.keys.sorted(), id: \.self) { state in
                    Section(header: Text(state)) {
                        ForEach(groupedCommunities[state]!.sorted(by: { $0.name < $1.name }), id: \.id) { community in
                            NavigationLink (value: Router.Destination.communityHomePageView(community)) {
                                Text(community.name)
                            }
                        }
                    }
                }
            }
            .toolbar {
                Menu("Sort", systemImage: "arrow.up.arrow.down") {
                    Picker ("Sort", selection: $sortType) {
                        Text ("Distance").tag("distance")
                        Text ("State").tag("state")
                        Text ("Map").tag ("map")
                    }
                    .pickerStyle(.inline)
                }
            }
        } else if (sortType == "map") {
        
            Map(position: $cameraPosition, selection: $selectedTag) {
                
                UserAnnotation()
                
                withAnimation {
                    ForEach(remoteCommunities, id:\.self) { community in
                        
                        Annotation(community.name, coordinate: community.coordinate) {
                            Button {
                                selectedRemoteCommunity = community
                                isPresenting = true
                            } label: {
                                NavigationLink (value: Router.Destination.communityHomePageView(community)) {
                                    Image(systemName: "mappin.circle.fill")
                                        .foregroundColor(.red)
                                        .font(.title)
                                }
                            }
                        }
                    }
                }
            }
            .navigationDestination(item: $selectedRemoteCommunity) { community in
                RemoteCommunityView(remoteCommunity: community)
            }
//            .onChange(of: selectedTag ?? "", { oldValue, newValue in
//                print ("mapSelection.name = " + String (newValue))
//                
//             })
            .toolbar {
                Menu("Sort", systemImage: "arrow.up.arrow.down") {
                    Picker ("Sort", selection: $sortType) {
                        Text ("Distance").tag("distance")
                        Text ("State").tag("state")
                        Text ("Map").tag ("map")
                    }
                    .pickerStyle(.inline)
                }
            }
        } else if (sortType == "distance") {
            List {
                ForEach (sortedLocations) { community in
                    NavigationLink (value: Router.Destination.communityHomePageView(community)) {
                        VStack(alignment: .center) {
                            HStack (alignment: .center) {
                                VStack (alignment: .leading) {
                                    Text (community.name)
                                    Text (community.traditionalName ?? "")
                                        .italic()
                                        .foregroundStyle(.gray)
                                    
                                    if let distance = community.distance(from: locationManager.currentLocation) {
                                        //if let distance = location.distance(from: locationManager.currentLocation) {
                                        Text("Distance: \(distance / 1000, specifier: "%.2f") km")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    } else {
                                        Text("Calculating distance...")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
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
            .toolbar {
                Menu("Sort", systemImage: "arrow.up.arrow.down") {
                    Picker ("Sort", selection: $sortType) {
                        Text ("Distance").tag("distance")
                        Text ("State").tag("state")
                        Text ("Map").tag ("map")
                    }
                    .pickerStyle(.inline)
                }
            }
        }
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
