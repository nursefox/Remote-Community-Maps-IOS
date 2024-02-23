////
////  HealthCentre.swift
////  Remote Community Maps
////
////  Created by Benjamin Fox on 7/1/2024.
////
//
//import Foundation
//import MapKit
//import SwiftData
//
//@Model
//class HealthCentre: Codable, Hashable {
//    var name: String
//    var controllingOrganisation: String
//    var address: String
//    var state: String
//    var postCode: String
//    var country: String
//    var phoneNumber: String
//    var latitude: Double
//    var longitude: Double
//    
//    var manager: String?
//    
//    var coordinates: CLLocationCoordinate2D {
//        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
//    }
//    
//    
//
//    private enum CodingKeys: String, CodingKey {
//        case name,
//             controllingOrganisation,
//             address,
//             state,
//             postCode,
//             country,
//             phoneNumber,
//             latitude,
//             longitude,
//             manager
//    }
//    
//    required init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.name = try container.decode(String.self, forKey: .name)
//        self.controllingOrganisation = try container.decode(String.self, forKey: .controllingOrganisation)
//        self.address = try container.decode(String.self, forKey: .address)
//        self.state = try container.decode(String.self, forKey: .state)
//        self.postCode = try container.decode(String.self, forKey: .postCode)
//        self.country = try container.decode(String.self, forKey: .country)
//        self.phoneNumber = try container.decode(String.self, forKey: .phoneNumber)
//        self.latitude = try container.decode(Double.self, forKey: .latitude)
//        self.longitude = try container.decode(Double.self, forKey: .longitude)
//        self.manager = try container.decode(String.self, forKey: .manager)
//    }
//    
//    init(name: String, 
//         controllingOrganisation: String,
//         address: String,
//         state: String,
//         postCode: String,
//         country: String,
//         phoneNumber: String,
//         latitude: Double,
//         longitude: Double,
//         manager: String) {
//        
//        self.name = name
//        self.controllingOrganisation = controllingOrganisation
//        self.address = address
//        self.state = state
//        self.postCode = postCode
//        self.country = country
//        self.phoneNumber = phoneNumber
//        self.latitude = latitude
//        self.longitude = longitude
//        self.manager = manager
//    }
//    
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(name, forKey: .name)
//    }
//}
//
