//
//  Bundle-Decodable.swift
//  Remote Community Maps
//
//  Created by Benjamin Fox on 16/12/2023.
//

import Foundation
import MapKit
import SwiftData

extension Bundle {
    func decode<T: Decodable>(
        _ type: T.Type,
        from file: String,
        dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate,
        keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys
    ) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle.")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle.")
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = dateDecodingStrategy
        decoder.keyDecodingStrategy = keyDecodingStrategy
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch DecodingError.keyNotFound(let key, let context) {
            fatalError("Failed to decode \(file): missing key '\(key.stringValue)' – \(context.debugDescription)")
        } catch DecodingError.typeMismatch(_, let context) {
            fatalError("Failed to decode \(file): type mismatch – \(context.debugDescription)")
        } catch DecodingError.valueNotFound(let type, let context) {
            fatalError("Failed to decode \(file): missing \(type) value – \(context.debugDescription)")
        } catch DecodingError.dataCorrupted(_) {
            fatalError("Failed to decode \(file): invalid JSON.")
        } catch {
            fatalError("Failed to decode \(file): \(error.localizedDescription)")
        }
    }
    
    
    func decodeGeoJSON (
        context: ModelContext,
        community: RemoteCommunity,
        from file: String)
    {
        guard let url = Bundle.main.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle.")
        }
        
       // var lotInformationArray = [LotInformation]()
        
        do {
            
            guard let data = try? Data(contentsOf: url) else {
                fatalError("Failed to load \(file) from bundle.")
            }
            
            let decoder = MKGeoJSONDecoder()
            let jsonObjects = try decoder.decode(data)
            
            
            
            for object in jsonObjects {
                /**
                 In this sample's GeoJSON data, there are only GeoJSON features at the top level, so this parse method only checks for those. An
                 implementation that parses arbitrary GeoJSON files needs to check for GeoJSON geometry objects too.
                 */
                if let feature = object as? MKGeoJSONFeature {
                    for geometry in feature.geometry {
                        do {
                            let response = try JSONDecoder().decode(PropertyResponse.self, from: feature.properties!)
                            
                            if let point = geometry as? MKPointAnnotation {
                                // Copy the geoInformation across to the Lot Map Data Model
                                
                                print ("lot name = " + String (response.name))
                                
                                let lotInfo = LotInformation(
                                    name: String (response.name),
                                    details: response.description ?? "",
                                    latitude: point.coordinate.latitude,
                                    longitude: point.coordinate.longitude,
                                    colourDescriptor: response.colourDescriptor ?? "",
                                    unitIdentifier: response.unitIdentifier ?? ""
                                )
                                
                                community.lotData.append(lotInfo)
                                context.insert(lotInfo)
                                
                             //   lotInformationArray.append(lotInfo)
                            }
                        } catch DecodingError.typeMismatch {
                            let response = try JSONDecoder().decode(PropertyResponseInt.self, from: feature.properties!)
                            
                            if let point = geometry as? MKPointAnnotation {
                                // Copy the geoInformation across to the Lot Map Data Model
                                let lotInfo = LotInformation(
                                    name: String (response.name),
                                    details: response.description ?? "",
                                    latitude: point.coordinate.latitude,
                                    longitude: point.coordinate.longitude,
                                    colourDescriptor: response.colourDescriptor ?? "",
                                    unitIdentifier: response.unitIdentifier ?? ""
                                )
                                
                                community.lotData.append(lotInfo)
                                context.insert(lotInfo)
                                
                                //lotInformationArray.append(lotInfo)
                            }
                        }
                    }
                }
            }
        } catch DecodingError.keyNotFound(let key, let context) {
            fatalError("Failed to decode \(file): missing key '\(key.stringValue)' – \(context.debugDescription)")
        } catch DecodingError.typeMismatch(_, let context) {
            fatalError("Failed to decode \(file): type mismatch – \(context.debugDescription)")
        } catch DecodingError.valueNotFound(let type, let context) {
            fatalError("Failed to decode \(file): missing \(type) value – \(context.debugDescription)")
        } catch DecodingError.dataCorrupted(_) {
            fatalError("Failed to decode \(file): invalid JSON.")
        } catch {
            fatalError("Failed to decode \(file): \(error.localizedDescription)")
        }
        
        //return lotInformationArray
        
    }
    
    struct PropertyResponse: Decodable {
        let name: String
        let description: String?
        let colourDescriptor: String?
        let unitIdentifier: String?
    }
    
    struct PropertyResponseInt: Decodable {
        let name: Int
        let description: String?
        let colourDescriptor: String?
        let unitIdentifier: String?
    }
}
