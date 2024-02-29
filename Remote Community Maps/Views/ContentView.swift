//
//  ContentView.swift
//  Remote Community Maps
//
//  Created by Benjamin Fox on 16/12/2023.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var locationDataManager: LocationDataManager
    //@EnvironmentObject var authService: AuthenticationManager
    @StateObject var firestoreManager = FirestoreManager.shared
    @StateObject var fruitDataStore = CloudDataStoreFruit.shared
    @StateObject var remoteCommunityDataStore = CloudDataStoreRemoteCommunity.shared
    
    @Environment(\.modelContext) var modelContex
    
    @State private var showSignInView: Bool = false
    
    
    //@StateObject var dataStore = CloudDataStoreRemoteCommunity.shared
    
    @State private var path = [RemoteCommunity]()
    @State private var sortOrder = [
        SortDescriptor(\RemoteCommunity.name, order: .reverse),
    ]
    
    @Query(sort: \RemoteCommunity.name, order: .reverse) var remoteCommunities: [RemoteCommunity]
    //    @Query(sort: \LotInformation.lotName, order: .forward) var lotInformation: [LotInformation]
    
    
    //    @Query( sort: [
    //        SortDescriptor(\LotInformation.remoteCommunity?.communityName),
    //        SortDescriptor(\LotInformation.lotName)
    //    ] )
    //    var lotInfoArray: [LotInformation]
    
    
    //var remoteCommunities: Array<RemoteCommunity> { Array(Set(lotInfoArray.compactMap{ $0.remoteCommunity })) }
    
    //@State private var path = [Int]()
    
    var columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    @State private var searchText = ""
    
    var body: some View {
        
        //        ZStack {
        //            Color.purple
        //        }
        //        .edgesIgnoringSafeArea(.all)
        //        .frame(height: 50)
        
        NavigationStack {
            VStack (alignment: .center) {
                
                RemoteCommunitiesListView(sort: sortOrder, searchString: searchText)
                    .searchable (text: $searchText)
                //                    .navigationDestination(for: RemoteCommunity.self, destination: EditDestinationView.init)
                //
                //
                //                List {
                //                    ForEach (remoteCommunities) { community in
                //
                //                        NavigationLink (value: Router.Destination.communityHomePageView(community)) {
                //                            VStack(alignment: .center) {
                //                                HStack (alignment: .center) {
                //                                    VStack (alignment: .leading) {
                //                                        Text (community.name)
                //                                        Text (community.indigenousName ?? "")
                //                                            .italic()
                //                                            .foregroundStyle(.gray)
                //                                    }
                //
                //                                    Spacer()
                //                                    Image(community.imageFileName)
                //                                        .resizable()
                //                                        .aspectRatio(contentMode: .fill)
                //                                        .frame(width: 180, height: 100)
                //                                        .background(.white)
                //                                        .clipShape(RoundedRectangle(cornerRadius: 15.0))
                //                                        .shadow(radius: 8)
                //                                }
                //                            }
                //                        }
                //                    }
                //                }
                //                .listStyle(.plain)
                    .toolbar {
                        
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Delete All Data") {
                                do {
                                    try modelContex.delete(model: RemoteCommunity.self)
                                    try modelContex.delete(model: LotInformation.self)
                                } catch {
                                    print ("Failed to clear data")
                                }
                            }
                        }
                        // Button("Add Destination", systemImage: "plus", action: createNewMap)
                        
                        
                        ToolbarItem(placement: .navigationBarTrailing) {
                            NavigationLink(destination: CloudAllRemoteCommunitiesView().environmentObject(self.remoteCommunityDataStore)) {
                                Image(systemName: "plus")
                            }
                            .environmentObject(remoteCommunityDataStore)
                        }
                        
                        ToolbarItem(placement: .navigationBarTrailing) {
                            NavigationLink(destination: CloudAllFruitsView().environmentObject(self.fruitDataStore)) {
                                Image(systemName: "cross")
                            }
                            .environmentObject(fruitDataStore)
                        }
                            
                            //                        NavigationLink(destination: StartView().environmentObject(self.authService)) {
                            //                            Image(systemName: "key")
                            //                        }
                            //                        .environmentObject(authService)
                            
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button(action: {
                                showSignInView = true
                            }, label: {
                                Image(systemName: "person.circle")
                            })
                        }
                            
                            
                            
                            
                            
                            
                            
                            
                        //}
                        
                        
                    }
                //.searchable (text: $searchText)
                    .navigationDestination(for: Router.Destination.self) { destination in
                        switch destination {
                            
                        case let .communityHomePageView (community):
                            RemoteCommunityView(remoteCommunity: community)
                            
                        case let .communitySearchView (community):
                            RemoteCommunitySearchView (remoteCommunity: community)
                            
                        case let .communityAllLocations (community):
                            RemoteCommunityMapAllLocationsView(remoteCommunity: community)
                            
                        case let .communityEditColours (community):
                            LotInformationEditLotColours(remoteCommunity: community)
                            
                        case let .communityAddPointOfInterest (community):
                            AddPointOfInterestView (remoteCommunity: community)
                            
                        case let .communityListOfLocations(community):
                            LocationListView(remoteCommunity: community)
                            
                        case let .lotInfoDetailView (lotInfo):
                            LotInformationDetailView(lotInfo: lotInfo)
                            
                        case let .lotDetailAndMapView (lotInfo):
                            LotDetailAndMapView(lotInfo: lotInfo)
                            
                        case let .lotInfoEditView (lotInfo):
                            LotInformationEditView(lotInfo: lotInfo, lotName: .constant(lotInfo.name))
                            
                            //                    case let .cloudAllFruitsView:
                            //                        CloudAllRemoteCommunitiesView()
                            //
                            //                    case let .cloudRemoteCommunityView (cloudRemoteCommunity):
                            //                        CloudRemoteCommunityDetailView(remoteCommunity: cloudModelRemoteCommunity)
                            
                            
                            // case cloudAllFruitsView
                            // case cloudAllRemoteCommunitiesView
                            // case cloudRemoteCommunityView (RemoteCommunity)
                            
                            
                        }
                    }
            }
            
            //.navigationBarTitle("Remote Community Maps", displayMode: .inline)
            .navigationBarTitle("RCM", displayMode: .automatic)
            Spacer()
            
            //            List {
            //                ForEach(remoteCommunities) { community in
            //                    HStack (spacing: 20) {
            //                        ImageCardView(imageName: community.communityImageFileName, communityName: community.communityName)
            //
            //                        NavigationLink(value: community) {
            //                            Text(community.communityName)
            //                        }
            //                }
            
            //                NavigationLink {
            //                    DraggablePinTestView()
            //                } label: {
            //                    Text("Drag Pin Test")
            //                }
            //
            //                NavigationLink {
            //                    AddPointOfInterestView(remoteCommunity: remoteCommunities.first!)
            //                } label: {
            //                    Text("Add New POI Test")
            //                }
        }
        .sheet(isPresented: $showSignInView) {
            NavigationStack {
                SettingsView()
                //SettingsView($showSignInView)
                //RootView()
                //StartView()
                //SignInMethodView(showSignInView: $showSignInView)
                //AuthenticationView(showSignInView: $showSignInView)
            }
        }
        
    }
    
    
    func createNewMap() {
        //        let newCommunity = RemoteCommunity
        //        modelContext.insert(RemoteCommunity)
        //   path = [destination]
    }
}

#Preview {
    ContentView()
        .modelContainer(DataController.previewContainer)
    //.environmentObject(AuthenticationManager.shared)
        .environmentObject(FirestoreManager.shared)
}
