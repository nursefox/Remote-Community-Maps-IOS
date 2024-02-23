//
//  LotInformation.swift
//  Remote Community Maps
//
//  Created by Benjamin Fox on 16/12/2023.
//

import Foundation
import MapKit
import SwiftData

@Model
class LotInformation: Codable, Hashable {
    var name: String
    var details: String
    var latitude: Double
    var longitude: Double
    var colourDescriptor: String?
    var unitIdentifier: String?
    var updatedByUser: Bool?
    var submittedForApproval: Bool?
    
    var lotCoordinates: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    private enum CodingKeys: String, CodingKey {
        case name,
             details,
             latitude,
             longitude,
             colourDescriptor,
             unitIdentifier
    }
    
    var remoteCommunity: RemoteCommunity?
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.details = try container.decode(String.self, forKey: .details)
        self.latitude = try container.decode(Double.self, forKey: .latitude)
        self.longitude = try container.decode(Double.self, forKey: .longitude)
        self.colourDescriptor = try container.decode(String.self, forKey: .colourDescriptor)
        self.unitIdentifier = try container.decode(String.self, forKey: .unitIdentifier)
    }
    
    init(name: String, details: String, latitude: Double, longitude: Double, colourDescriptor: String, unitIdentifier: String) {
        self.name = name
        self.details = details
        self.latitude = latitude
        self.longitude = longitude
        self.colourDescriptor = colourDescriptor
        self.unitIdentifier = unitIdentifier
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
    }
}
