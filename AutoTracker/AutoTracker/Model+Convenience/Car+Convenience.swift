//
//  Car+Convenience.swift
//  AutoTracker
//
//  Created by Ian Hall on 10/3/19.
//  Copyright © 2019 DjangoEarnhardt. All rights reserved.
//

import UIKit
import CoreData
import CloudKit
import CoreLocation

extension Car {
    
    convenience init(name:String,
                     
                     make:String,
                     
                     model:String,
                     
                     year:String,
                     
                     engine:String,
                     
                     ownerName:String,
                     
                     odometer: Double,
                     
                     photoData: Data?,
                     
                     context: NSManagedObjectContext = CoreDataStack.context){
        
        self.init(context:context)
        
        self.name = name
        
        self.make = make
        
        self.model = model
        
        self.year = year
        
        self.engine = engine
        
        self.ownerName = ownerName
        
        //below data will be initialized to 0 until the user sets a location
        
        self.altitude = 0
        
        self.lattitude = 0
        
        self.longitude = 0
        
        self.recordID = UUID().uuidString
        
        self.odometer = odometer
        
        self.photoData = photoData
        
    }
    
    convenience init(name: String, odometer: Double, photoData: Data?, context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        self.name = name
        self.odometer = odometer
        self.photoData = photoData
    }
    
 
}



extension Car {
    
    var photo: UIImage? {
        get {
            guard let photoData = photoData else { return nil }
            return UIImage(data: photoData)
        } set {
            photoData = newValue?.jpegData(compressionQuality: 0.5)
        }
    }
}
