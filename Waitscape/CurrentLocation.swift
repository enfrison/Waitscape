//
//  CurrentLocation.swift
//  Waitscape
//
//  Created by Erika Frison on 5/24/22.
//

import CoreLocationUI
import MapKit
import SwiftUI

struct CurrentLocation: View {
    
@StateObject private var viewModel = ContentViewModel()
    
    var body: some View {
        ZStack(alignment: .bottom){
            Map(coordinateRegion: $viewModel.region, showsUserLocation: true)
                .ignoresSafeArea()
                .tint(.pink)
            
            LocationButton(.currentLocation) {
                viewModel.requestLocationPermission()
                
            }
            .foregroundColor(.white)
            .cornerRadius(8)
            .labelStyle(.iconOnly)
            .symbolVariant(.fill)
            .tint(Color("Waitscape Orange"))
            .padding(.bottom, 50)
        }
    }
}

struct CurrentLocation_Previews: PreviewProvider {
    static var previews: some View {
        CurrentLocation()
    }
}

final class ContentViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 50, longitude: 160), span: MKCoordinateSpan(latitudeDelta: 100, longitudeDelta: 100))
    
    let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func requestLocationPermission() {
        locationManager.requestLocation()
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.first else{
            //show an error
            return
        }
        DispatchQueue.main.async {
            self.region = MKCoordinateRegion(center: latestLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.09, longitudeDelta: 0.09))
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
}
