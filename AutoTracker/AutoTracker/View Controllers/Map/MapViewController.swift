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
    
    @IBOutlet weak var locationTitleLabel: UILabel!
    
    @IBOutlet weak var locationYelpStarsImage: UIImageView!
    
    @IBOutlet weak var totalReviewsLabel: UILabel!
    
    @IBOutlet weak var addressButton: AutoTrackerButtonGreenBG!
    
    @IBOutlet weak var locationImage: UIImageView!
    
    @IBOutlet weak var cardView: UIView!
    
    @IBOutlet weak var yelpButton: UIButton!
    
    @IBOutlet weak var searchAreaButton: AutoTrackerButtonGreenBG!
    
    
    //MARK: -VARIABLES
    
    var results = [PlaceObject]()
    
    var currentLocation: CLLocation?
    
    let locationManager = LocationManager.shared
    
    var selectedPlace:PlaceObject?
    
    var hideLocationCard:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationsMapView.delegate = self
        activityIndicator.stopAnimating()
        toggleLocationCard()
        view.sendSubviewToBack(locationsMapView)
        searchAreaButton.layer.shadowRadius = 10
        searchAreaButton.layer.shadowOffset = .zero
        searchAreaButton.layer.shadowColor = UIColor.black.cgColor
        searchAreaButton.layer.shadowOpacity = 0.5
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        locationManager.stopUpdatingLocation()
    }
    
    
    //MARK: - ACTIONS
    
    @IBAction func searchAreaButtonTapped(_ sender: Any) {
        searchArea()
    }
    
    @IBAction func addressButtonTapped(_ sender: Any) {
        getDirectionsInAppleMaps()
    }
    
    @IBAction func yelpButtonTapped(_ sender: Any) {
        goToYelpPage()
    }
    
    
    @IBAction func screenTapped(_ sender: Any) {
        if hideLocationCard == false{
            toggleLocationCard()
        }
        
    }
    
    
    
    //MARK: - HELPERS
    func toggleLocationCard(){
        hideLocationCard.toggle()
        cardView.layer.shadowRadius = 10
        cardView.layer.shadowOffset = .zero
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.5
        if hideLocationCard{
            locationImage.isHidden = true
            cardView.isHidden = true
            totalReviewsLabel.isHidden = true
            locationYelpStarsImage.isHidden = true
            yelpButton.isHidden = true
            locationTitleLabel.isHidden = true
            addressButton.isHidden = true
        } else {
            guard let place = selectedPlace else {return}
            locationImage.isHidden = false
            cardView.isHidden = false
            totalReviewsLabel.isHidden = false
            locationYelpStarsImage.isHidden = false
            yelpButton.isHidden = false
            locationTitleLabel.isHidden = false
            addressButton.isHidden = false
            retrieveAndSetImage(place: place)
            locationYelpStarsImage.image = place.ratingImage
            totalReviewsLabel.text = "Based on \(place.numberOfReviews) reviews!"
            locationTitleLabel.text = place.title ?? "No Name Provided"
            addressButton.setTitle(place.address, for: .normal)
            
        }
    }
    func searchArea() {
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
                    self.results = MapController.shared.results
                    self.setUpMarkers()
                }
                
                
            }
        }
    }
    func retrieveAndSetImage(place: PlaceObject) {
        guard let image = place.imageURL else {return}
        MapController.shared.retrieveImage(urlString: image) { (imageOptional) in
            guard let imageUnwrapped = imageOptional else {return}
            DispatchQueue.main.async {
                self.locationImage.image = imageUnwrapped
            }
            
        }
        
    }
    
    func presentNoInternetAlert() {
        let alert = UIAlertController(title: "No Internet", message: "Sorry but this function requires an internet connection.  check your connection and try again", preferredStyle: .alert)
        let okayButton = UIAlertAction(title: "okay", style: .default, handler: nil)
        alert.addAction(okayButton)
        self.present(alert, animated: true)
    }
    
    func goToYelpPage(){
        if !Reachability.isConnectedToNetwork(){
            presentNoInternetAlert()
            return
        }
        guard let place = self.selectedPlace else {return}
        let alertController = UIAlertController(title: "Open this Business's page on Yelp?", message: "This will open Safari and display \(place.title ?? "")'s Yelp Page", preferredStyle: .alert)
        let okayButton = UIAlertAction(title: "Open", style: .default) { (_) in
            guard let url = URL(string: place.url) else {return}
            UIApplication.shared.open(url)
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alertController.addAction(okayButton)
        alertController.addAction(cancelButton)
        self.present(alertController, animated: true)
    }
    
    func getDirectionsInAppleMaps(){
        if !Reachability.isConnectedToNetwork(){
            presentNoInternetAlert()
            return
        }
        guard let location = selectedPlace else {return}
        let alertController = UIAlertController(title: "Open in Apple Maps?", message: "This will give you directions to \(location.title ?? "")", preferredStyle: .alert)
        let okayButton = UIAlertAction(title: "Get Directions", style: .default) { (_) in
            let launchOptions = [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving]
            let placeMark = MKPlacemark(coordinate: location.coordinate)
            let mapitem = MKMapItem(placemark: placeMark)
            mapitem.name = "\(location.title ?? "")"
            mapitem.openInMaps(launchOptions: launchOptions)
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alertController.addAction(okayButton)
        alertController.addAction(cancelButton)
        self.present(alertController, animated: true)
    }
    func centerMapOnLocation(location:CLLocation,regionRadius:CLLocationDistance){
        
        let region:MKCoordinateRegion = MKCoordinateRegion.init(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        locationsMapView.setRegion(region, animated: false)
        searchArea()
        
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
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let place = view.annotation as! PlaceObject
        selectedPlace = place
        toggleLocationCard()
    }
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        if hideLocationCard == false{
            toggleLocationCard()
        }
        
    }
}
