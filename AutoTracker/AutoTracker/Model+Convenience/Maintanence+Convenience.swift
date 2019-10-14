//
//  Maintanence+Convenience.swift
//  AutoTracker
//
//  Created by Ian Hall on 10/4/19.
//  Copyright © 2019 Ian Hall. All rights reserved.
//

import UIKit
import CoreData
import CloudKit

extension Maintanence {
    
    convenience init(duedate: Date?, maintanenceRequiered:String, details: String, car:Car, price:String, context: NSManagedObjectContext = CoreDataStack.context){
        self.init(context:context)
        
        self.dueOn = duedate
        
        self.maintanenceRequired = maintanenceRequiered
        
        self.details = details
        
        self.car = car
        
        self.price = price
        
        self.odometerStamp  = car.odometer
        
        self.isComplete = true
        
    }
    
}
//TODO: - ADD CKRECORD FUNCTIONALITY IF IT DOESNT GET PUSHED TO THE CLOUD
extension Maintanence {
    
    var photo: UIImage? {
        get {
            guard let photoData = photoData else { return nil }
            return UIImage(data: photoData)
        } set {
            photoData = newValue?.jpegData(compressionQuality: 0.5)
        }
    }
}
