//
//  Airport.swift
//  Waitscape
//
//  Created by Devin Allen on 6/7/22.
//

import Foundation

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
}
 
