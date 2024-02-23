//
//  CloudLotInformation.swift
//  Remote Community Maps
//
//  Created by Benjamin Fox on 17/2/2024.
//

import Foundation

struct CloudLotInformation: Codable {
    var name: String = ""
    var details: String = ""
    var latitude: Double = 0.00
    var longitude: Double = 0.00
    var colourDescriptor: String?
    var unitIdentifier: String?    
}
