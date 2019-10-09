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
    
    var results = [Place]()
    
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
        MapController.shared.retrieveGasStationsNearby(location: center, radius: radius) { (success) in
            print("yay")
        }
    }
    
    
    
    //MARK: - HELPERS
    func centerMapOnLocation(location:CLLocation,regionRadius:CLLocationDistance){
     
        let region:MKCoordinateRegion = MKCoordinateRegion.init(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        locationsMapView.setRegion(region, animated: true)
        
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
