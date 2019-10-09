//
//  MapDetailViewController.swift
//  AutoTracker
//
//  Created by Ian Hall on 10/8/19.
//  Copyright © 2019 Ian Hall. All rights reserved.
//

import UIKit
import MapKit

class MapDetailViewController: UIViewController {
    
    
    //MARK: - OUTLETS
    
    @IBOutlet weak var locationTitleLabel: UILabel!
    
    @IBOutlet weak var addressButton: AutoTrackerButtonAsLabel!
    
    @IBOutlet weak var imageOfPlace: UIImageView!
    
    @IBOutlet weak var yelpStarsImage: UIImageView!
    
    @IBOutlet weak var totalReviewsLabel: UILabel!
    
    var place:PlaceObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    //MARK: - HELPERS
    
    
    func setUpUI(){
        guard let place = place else {return}
        locationTitleLabel.text = place.title
        addressButton.setTitle(place.address, for: .normal)
        
        yelpStarsImage.image = place.ratingImage
        totalReviewsLabel.text = "Based on \(place.ratingCount) reviews"
        if let imageurl = place.imageURL{
            MapController.shared.retrieveImage(urlString: imageurl) { (image) in
                guard let image = image else {return}
                DispatchQueue.main.async {
                    self.imageOfPlace.image = image
                }
                
            }
        }
        
    }
    
    
    
    //MARK: - ACTIONS
    
    @IBAction func yelpButtonTapped(_ sender: UIButton) {
        guard let place = place else {return}
        guard let url = URL(string: place.url) else {return}
        UIApplication.shared.open(url)
        
    }
    
    @IBAction func addressButtonTapped(_ sender: Any) {
        guard let place = place else {return}
        let launchOptions = [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving]
        let placeMark = MKPlacemark(coordinate: place.coordinate)
        let mapitem = MKMapItem(placemark: placeMark)
        mapitem.name = "\(place.title ?? "")"
        mapitem.openInMaps(launchOptions: launchOptions)
        
    }
    
    
    
    
}
