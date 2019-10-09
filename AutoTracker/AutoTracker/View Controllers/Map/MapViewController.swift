//
//  MapViewController.swift
//  AutoTracker
//
//  Created by Ian Hall on 10/8/19.
//  Copyright © 2019 Ian Hall. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    
    
    //MARK: -OUTLETS
    
    @IBOutlet weak var locationsMapView: MKMapView!
    
    
    
    
    
    //MARK: -VARIABLES
    
    var results = [PlaceObject]()
    
    var currentLocation: CLLocation?
    
    let locationManager = LocationManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        locationManager.stopUpdatingLocation()
    }
    
    
    //MARK: - ACTIONS
    
    @IBAction func searchAreaButtonTapped(_ sender: Any) {
        let center = locationsMapView.centerCoordinate
        let radius = Int(locationsMapView.region.span.longitudeDelta)
        MapController.shared.grabNearbyGasStationsAndConvert(location: center, radius: radius) { (success) in
            if success{
                self.results = MapController.shared.results
                self.setUpMarkers()
            }
        }
        
        
    }
    
    
    
    //MARK: - HELPERS
    func centerMapOnLocation(location:CLLocation,regionRadius:CLLocationDistance){
        
        let region:MKCoordinateRegion = MKCoordinateRegion.init(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        locationsMapView.setRegion(region, animated: true)
        
    }
    func setUpMarkers(){
        locationsMapView.addAnnotations(results)
    }
    
    
}
extension MapViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for location in locations{
            guard let _ = currentLocation else {
                centerMapOnLocation(location: location, regionRadius: 12000)
                currentLocation = location
                continue
                
            }
            currentLocation = location
        }
    }
}
extension MapViewController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? PlaceObject else {return nil}
        let identifier = "marker"
        var view: MKMarkerAnnotationView
        if let dequedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
            dequedView.annotation = annotation
            view = dequedView
        } else {
            view  = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }
}
