//
//  Place.swift
//  AutoTracker
//
//  Created by Ian Hall on 10/8/19.
//  Copyright © 2019 Ian Hall. All rights reserved.
//

import Foundation
import MapKit
struct Places:Decodable{
    let businesses:[Place]
}

struct Place:Decodable{
    let name: String
    let coordinates:Coordinates
    let imageURL:String?
    let rating: Double
    let address:Address
    let reviewCount:Int
    let url:String
    private enum CodingKeys:String, CodingKey{
        case imageURL = "image_url"
        case name
        case coordinates
        case rating
        case address = "location"
        case reviewCount = "review_count"
        case url
    }
}
struct Coordinates:Decodable{
    let latitude:Double
    let longitude:Double
}
struct Address:Decodable{
    let displayAddress:[String]
    
    private enum CodingKeys:String,CodingKey{
        case displayAddress = "display_address"
    }
}

class PlaceObject: NSObject, MKAnnotation{
    let title:String?
    let coordinate: CLLocationCoordinate2D
    let image: UIImage?
    let rating: Double
    let ratingImage: UIImage
    let address: String
    let numberOfReviews:Int
    let imageURL: String?
    let url:String
    let ratingCount:Int
    
    init (place:Place, imageurl:String?, ratingImage:UIImage){
        self.title = place.name
        self.coordinate = CLLocationCoordinate2D(latitude: place.coordinates.latitude, longitude: place.coordinates.longitude)
        self.ratingImage = ratingImage
        self.address = place.address.displayAddress.first ?? "Address not available"
        
        self.rating = place.rating
        
        self.numberOfReviews = place.reviewCount
        
        self.url = place.url
        
        self.ratingCount = place.reviewCount
        
        self.imageURL = imageurl
        
        self.image = nil
        
    }
    
    var subtitle: String?{
        return address
    }
}
