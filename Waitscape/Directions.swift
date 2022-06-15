////
////  Directions.swift
////  Waitscape
////
////  Created by Cal Roskopp on 6/13/22.
////
//
//import Foundation
//import MapKit
//import UIKit
//import CoreLocation
//
//class MKMapView : UIView {
//
//class ViewController: UIViewController, MKMapViewDelegate {
//    @IBOutlet var mapView: MKMapView!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        let request = MKDirections.Request()
//        request.source = MKMapItem(placemark: MKPlaceMark(coordinate: CLLocationCoordinate2D(latitude: 40.7127, longitude: -74.0059), addressDictionary: nil))
//        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 37.783333, longitude: -122.416667), addressDictionary: nil))
//        request.requestsAlternateRoutes = true
//        request.transportType = .automobile
//        
//        let directions = MKDirections(request: request)
//        
//        directions.calculate {
//            [unowned self] response, error in
//            guard let unwrappedResponse = response else { return }
//            
//            for route in unwrappedResponse.routes {
//                self.mapView.addOverlay(route.polyline)
//                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
//            }
//        }
//    }
//    private func mapView( _ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
//        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
//        renderer.strokeColor = UIColor.blue
//        return renderer
//    }
//}
//}
