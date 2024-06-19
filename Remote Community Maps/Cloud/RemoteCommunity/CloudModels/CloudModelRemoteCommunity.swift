//
//  CloudRemoteCommunity.swift
//  Remote Community Maps
//
//  Created by Benjamin Fox on 17/1/2024.
//

import Foundation

struct CloudModelRemoteCommunity: Codable {
    var name: String = ""
    var traditionalName: String?
    var state: String = ""
    var country: String = ""
    var latitude: Double = 0.00
    var longitude: Double = 0.00
    var latitudinalMeters: Double = 0.00
    var longitudinalMeters: Double = 0.00
    var mapDataFileName: String = ""
    var imageFileName: String = ""
    var published: Bool = false
    
   // var lotData: [CloudLotInformation] = []
}
