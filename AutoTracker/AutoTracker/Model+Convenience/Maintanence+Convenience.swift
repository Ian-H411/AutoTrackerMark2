//
//  Maintanence+Convenience.swift
//  AutoTracker
//
//  Created by Ian Hall on 10/4/19.
//  Copyright © 2019 Ian Hall. All rights reserved.
//

import Foundation
import CoreData
import CloudKit
extension Maintanence {
    
    convenience init(duedate: Date?, maintanenceRequiered:String, details: String, car:Car, context: NSManagedObjectContext = CoreDataStack.context){
        self.init(context:context)
        
        self.dueOn = duedate
        
        self.maintanenceRequired = maintanenceRequiered
        
        self.details = details
        
        self.car = car
        
    }
    
}
//TODO: - ADD CKRECORD FUNCTIONALITY IF IT DOESNT GET PUSHED TO THE CLOUD
