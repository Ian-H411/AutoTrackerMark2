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
        self.isReceipt = false
        self.uuid = UUID().uuidString
    }
    // Receipt Initializer
    convenience init(car: Car, price: String, maintenanceRequired: String, odometerStamp: Double, details: String, isReceipt: Bool, context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        
        self.maintanenceRequired = maintenanceRequired
        self.car = car
        self.price = price
        self.odometerStamp = odometerStamp
        self.details = details
        self.isReceipt = isReceipt
    }
}
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
