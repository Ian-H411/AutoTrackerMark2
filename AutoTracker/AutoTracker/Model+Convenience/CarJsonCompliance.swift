//
//  CarJsonCompliance.swift
//  AutoTracker
//
//  Created by Ian Hall on 10/4/19.
//  Copyright © 2019 Ian Hall. All rights reserved.
//

import Foundation
struct CarResultsHead:Decodable{
    let Results: [CarJson]
}

struct CarJson:Decodable {
    
    let make: String
    
    let model: String
    
    let year:String
    
    let engine:String
    
    enum CodingKeys:String,CodingKey {
        case make = "Make"
        
        case model = "Model"
        
        case year = "ModelYear"
        
        case engine = "EngineCylinders"
    }
}
