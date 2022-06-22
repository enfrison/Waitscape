//
//  Airport.swift
//  Waitscape
//
//  Created by Erika Frison on 6/9/22.
//

import Foundation
import CoreLocation

struct Airport: Codable, Hashable {
    var code: String
    var name: String
    var state: String
    var latitude: String
    var longitude: String
    var precheck: String
    
    var formattedName: String {
        "\(code) - \(name)"
    }
    
    var coordinate: CLLocationCoordinate2D? {
        if let latitude = Double(latitude),
           let longitude = Double(longitude) {
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
     
        return nil
    }
}

