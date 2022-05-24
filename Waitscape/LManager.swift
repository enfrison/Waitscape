//
//  LManager.swift
//  Waitscape
//
//  Created by Cal Roskopp on 5/24/22.
//

import CoreLocation
import MapKit

enum mapDetails {
    static let startingLocation = CLLocationCoordinate2D(latitude: 37.3315, longitude: -121.8910)
    static let defaultSpan = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
}

final class LManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var region = MKCoordinateRegion(center: mapDetails.startingLocation, span: mapDetails.defaultSpan)
    
    var locationManager: CLLocationManager?
    
    func checkIfLocationServiceisEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager ()
            locationManager!.delegate = self
            print("Turn location Services on")
            
        }
    }
    
    func checkLocationAuthorization() {
        
        guard let locationManager = locationManager else {return}
        
        switch locationManager.authorizationStatus{
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
                print("notDetermined")
        case .restricted:
            print("Your location is restricted")
        case.denied:
            print("You have denied location services")
        case .authorizedAlways , .authorizedWhenInUse:
            if locationManager.location != nil {
                region = MKCoordinateRegion(center: locationManager.location!.coordinate, span:mapDetails.defaultSpan)
            }
            
        @unknown default:
            break
            
        }
       
    }
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        checkLocationAuthorization()
    }
    
    func requestAllowOnceLocationPermission() {
        locationManager?.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard locations.first != nil
        else {
            print("LatestLocation error")
            return
        }
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}

