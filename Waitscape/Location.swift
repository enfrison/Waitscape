//
//  Location.swift
//  Waitscape
//
//  Created by Cal Roskopp on 6/13/22.
//

import Foundation
import CoreLocation
import CoreLocationUI
import SwiftUI

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()
    
    @Published var location: CLLocationCoordinate2D?
    
    override init() {
        super.init()
        manager.delegate = self
    }
    
    func requestLocation() {
        manager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first?.coordinate
        }
}

struct LocationView: View {
    @StateObject var locationManager = LocationManager()
    
    var body: some View {
        VStack {
            if let location = locationManager.location {
                Text("Your Location: \(location.latitude), \(location.longitude)")
            }
            
            LocationButton {
                locationManager.requestLocation()
            }
            .frame(height: 44)
            .padding()
        }
    }
    
}

struct LocationView_Previews: PreviewProvider {
    static var previews: some View {
        LocationView()
    }
}

