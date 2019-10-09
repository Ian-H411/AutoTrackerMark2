//
//  Place.swift
//  AutoTracker
//
//  Created by Ian Hall on 10/8/19.
//  Copyright © 2019 Ian Hall. All rights reserved.
//

import Foundation

struct Places:Decodable{
    let businesses:[Place]
}

struct Place:Decodable{
    
    let name: String
    
    let coordinates:Coordinates
    
    let imageURL:String
    
    let rating: Double
    
    let address:Address
    
    private enum CodingKeys:String, CodingKey{
        case imageURL = "image_url"
        case name
        case coordinates
        case rating
        case address = "location"
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
