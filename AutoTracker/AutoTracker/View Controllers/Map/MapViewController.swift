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
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    
    
    //MARK: -VARIABLES
    
    var results = [PlaceObject]()
    
    var currentLocation: CLLocation?
    
    let locationManager = LocationManager.shared
    
    var selectedPlace:PlaceObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationsMapView.delegate = self
        activityIndicator.stopAnimating()
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        locationManager.stopUpdatingLocation()
    }
    
    
    //MARK: - ACTIONS
    
    @IBAction func searchAreaButtonTapped(_ sender: Any) {
        if !Reachability.isConnectedToNetwork(){
            presentNoInternetAlert()
            return
        }
        locationsMapView.removeAnnotations(locationsMapView.annotations)
        activityIndicator.startAnimating()
        let center = locationsMapView.centerCoordinate
        let radius = Int(locationsMapView.region.span.longitudeDelta)
        MapController.shared.grabNearbyGasStationsAndConvert(location: center, radius: radius) { (success) in
            if success{
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                }
                
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
    
    func presentNoInternetAlert(){
        let alert = UIAlertController(title: "No Internet", message: "Sorry but this function requires an internet connection.  check your connection and try again", preferredStyle: .alert)
        let okayButton = UIAlertAction(title: "okay", style: .default, handler: nil)
        alert.addAction(okayButton)
        self.present(alert, animated: true)
    }
    //MARK: - NAVIGATION
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "placeDetail"{
            if let vc = segue.destination as? MapDetailViewController {
                vc.place = selectedPlace
            }
        }
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
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let place = view.annotation as! PlaceObject
        selectedPlace = place
        self.performSegue(withIdentifier: "placeDetail", sender: nil)
    }
}
