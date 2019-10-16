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
                     
                     vin:String,
                     
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
        
        self.vin = vin
        
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
    
    convenience init(name: String, vin: String, odometer: Double, photoData: Data?, context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        self.name = name
        self.vin = vin
        self.odometer = odometer
        self.photoData = photoData
    }
    
    convenience init?(carjson: CarJson, name:String, vin:String, ownerName:String, odometer:Double, photoData: Data?, context:NSManagedObjectContext = CoreDataStack.context){
        self.init(context:context)
        self.name = name
        self.model = carjson.model
        self.make = carjson.make
        self.year = carjson.year
        self.vin = vin
        self.engine = carjson.engine
        self.ownerName = ownerName
        self.altitude = 0
        self.lattitude = 0
        self.longitude = 0
        self.recordID = UUID().uuidString
        self.odometer = odometer
        self.photoData = photoData
        
    }
}

//extension CKRecord{
//
//    convenience init?(car:Car){
//
//        guard let recordid = car.recordID else {return nil}
//
//        let recordIDinFormat = CKRecord.ID(recordName: recordid)
//
//        self.init(recordType:CarConstants.CarTypeKey, recordID:recordIDinFormat)
//
//        self.setValue(car.name, forKey: CarConstants.nameKey)
//
//        self.setValue(car.make, forKey: CarConstants.makeKey)
//
//        self.setValue(car.model, forKey: CarConstants.modelKey)
//
//        self.setValue(car.year, forKey: CarConstants.yearKey)
//
//        self.setValue(car.vin, forKey: CarConstants.vinKey)
//
//        self.setValue(car.engine, forKey: CarConstants.engineKey)
//
//        self.setValue(car.ownerName, forKey: CarConstants.engineKey)
//
//        self.setValue(car.altitude, forKey: CarConstants.altitudeKey)
//
//        self.setValue(car.lattitude, forKey: CarConstants.lattitudeKey)
//
//        self.setValue(car.longitude, forKey: CarConstants.longitudeKey)
//
//        self.setValue(car.photoData, forKey: CarConstants.photoKey)
//
//    }
//}

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
