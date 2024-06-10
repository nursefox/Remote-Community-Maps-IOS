//
//  Router.swift
//  Remote Community Maps
//
//  Created by Benjamin Fox on 6/1/2024.
//

import SwiftUI
import Foundation

final class Router: ObservableObject {
    
    public enum Destination: Codable, Hashable {
        case communityHomePageView (RemoteCommunity)
        case communitySearchView (RemoteCommunity)
        case communityAllLocations (RemoteCommunity)
        case communityEditColours (RemoteCommunity)
        case communityAddPointOfInterest (RemoteCommunity)
        case communityListOfLocations (RemoteCommunity)
        case communityRemoteManagement (RemoteCommunity)
        
        case lotInfoDetailView (LotInformation)
        case lotInfoEditView (LotInformation)
        case lotDetailAndMapView (LotInformation)
        
//        case cloudAllFruitsView
//        case cloudAllRemoteCommunitiesView
//        case cloudRemoteCommunityView (RemoteCommunity)
    }
        
    @Published var navPath = NavigationPath()
    
    func navigate(to destination: Destination) {
        navPath.append(destination)
    }
    
    func navigateBack() {
        navPath.removeLast()
    }
    
    func navigateToRoot() {
        navPath.removeLast(navPath.count)
    }
}


