//
//  RemoteCommunitySamples.swift
//  Remote Community Maps
//
//  Created by Benjamin Fox on 17/12/2023.
//

import Foundation

extension RemoteCommunity {
    static var remoteCommunitySamples: [RemoteCommunity] {
        [
            RemoteCommunity (name: "Santa Teresa",
                             traditionalName: "Ltyentye Apurte",
                             state: "Northern Territory",
                             country: "Australia",
                             latitude: -24.1301,
                             longitude: 134.37386,
                             latitudinalMeters: 1000,
                             longitudinalMeters: 1000,
                             mapDataFileName: "Santa Teresa - Lot Numbers.geojson",
                             imageFileName: "Santa-Teresa-Profile-Photo",
                             published: true),
            RemoteCommunity (name: "Hermannsburg (Ntaria)",
                             traditionalName: "Ntaria",
                             state: "Northern Territory",
                             country: "Australia",
                             latitude: -23.9433,
                             longitude: 132.7799,
                             latitudinalMeters: 1600,
                             longitudinalMeters: 1600,
                             mapDataFileName: "Hermannsburg-NT-Map-Data.geojson",
                             imageFileName: "Hermannsburg-NT",
                             published: true)
        ]
    }
}
