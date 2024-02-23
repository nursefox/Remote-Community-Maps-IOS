//
//  RemoteCommunity.swift
//  Remote Community Maps
//
//  Created by Benjamin Fox on 16/12/2023.
//

import Foundation
import MapKit
import SwiftData

@Model
class RemoteCommunity: Codable, Hashable {
    var name: String
    var traditionalName: String?
    var state: String
    var latitude: Double
    var longitude: Double
    var latitudinalMeters: Double
    var longitudinalMeters: Double
    var mapDataFileName: String
    var imageFileName: String
    var published: Bool
    
    @Relationship(deleteRule: .cascade, inverse: \LotInformation.remoteCommunity) 
    var lotData: [LotInformation]

   // var healthCentre: HealthCentre?
    
    init(name: String, traditionalName: String, state: String, latitude: Double, longitude: Double, latitudinalMeters: Double, longitudinalMeters: Double, mapDataFileName: String,  imageFileName: String, published: Bool) {
        self.name = name
        self.traditionalName = traditionalName
        self.state = state
        self.latitude = latitude
        self.longitude = longitude
        self.latitudinalMeters = latitudinalMeters
        self.longitudinalMeters = longitudinalMeters
        self.mapDataFileName = mapDataFileName
        self.imageFileName = imageFileName
        self.published = published
        
        self.lotData = [LotInformation]()
    }
    
    private enum CodingKeys: String, CodingKey {
        case name,
             traditionalName,
             state,
             latitude,
             longitude,
             latitudinalMeters,
             longitudinalMeters,
             mapDataFileName,
             imageFileName,
             published
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.traditionalName = try container.decodeIfPresent(String.self, forKey: .traditionalName)
        
        self.state = try container.decode(String.self, forKey: .state)
        self.latitude = try container.decode(Double.self, forKey: .latitude)
        self.longitude = try container.decode(Double.self, forKey: .longitude)
        self.latitudinalMeters = try container.decode(Double.self, forKey: .latitudinalMeters)
        self.longitudinalMeters = try container.decode(Double.self, forKey: .longitudinalMeters)
        self.mapDataFileName = try container.decode(String.self, forKey: .mapDataFileName)
        self.imageFileName = try container.decode(String.self, forKey: .imageFileName)
        self.published = try container.decode(Bool.self, forKey: .published)
        self.lotData = [LotInformation]()
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
    }
    
    
    public var orderedLots: [LotInformation] {
        lotData.sorted { lhs, rhs in
            lhs.name < rhs.name
        }
    }
 
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var region: MKCoordinateRegion {
        MKCoordinateRegion(center: coordinate, latitudinalMeters: latitudinalMeters, longitudinalMeters: longitudinalMeters)
    }
    
//    
//    static func ==(lhs: RemoteCommunity, rhs: RemoteCommunity) -> Bool {
//        return lhs.communityName == rhs.communityName
//    }
//    
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(id)
//    }
//    
    
}
