//
//  Routes.swift
//  Waitscape
//
//  Created by Cal Roskopp on 6/15/22.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

    func getDirections() {
        
        // Create a MKDirections.Request()
        let request = MKDirections.Request()
        
        // Create a CLLocationCoordinate2DMake for both your current location and destination location using the respective latitude and longitudes
        let currentLocationCoordinate = CLLocationCoordinate2D(latitude: 40.7127, longitude: -74.0059)
        let destinationCoordinate = CLLocationCoordinate2D(latitude: 37.783333, longitude: -122.416667)
        
        // Create two MKPlacemark for the source and destination using your two previously defined coordinates
        let currentLocationPlaceMark = MKPlacemark(coordinate: currentLocationCoordinate, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinate, addressDictionary: nil)
        
        // Set the request source property to an MKMapItem using your source MKPlacemark as the placemark
        request.source = MKMapItem(placemark: currentLocationPlaceMark)
        
        // Set the destination source property to an MKMapItem using your destination MKPlacemark as the placemark
        request.destination = MKMapItem(placemark: destinationPlacemark)

        // Optionally set the request’s transport type to automobile directions
        request.requestsAlternateRoutes = true
        request.transportType = .automobile
        
        // Create MKDirections using your configured request
        let directions = MKDirections(request: request)
        
        // Calculate the directions using the calculate function
        directions.calculate {
             response, error in
            
            // If the directions are calculated correctly, you will have an array of type MKRoute
            guard let unwrappedResponse = response,
                  let route = unwrappedResponse.routes.first else { return }
            
            // Each route has an expectedTravelTime property that is stored as a TimeInterval
            let expectedTravelTime = route.expectedTravelTime
            
            // In order to get the expected travel time printed in a readable way on screen you will need to create a DateComponentsFormatter and configure to whatever format your app requires
           let formatter = DateComponentsFormatter()
            formatter.includesTimeRemainingPhrase = true
            formatter.allowedUnits = [.minute]
            
            // Use the formatter’s string method to get the TimeInterval formatted as a String
            
            let formattedExpectedTravelTime = formatter.string(from: expectedTravelTime)
        }
    }
    private func mapView( _ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = UIColor.blue
        return renderer
    }


