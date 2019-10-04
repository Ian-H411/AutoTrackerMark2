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
        
    }
    
    convenience init? (record: CKRecord, context: NSManagedObjectContext = CoreDataStack.context){
        
        self.init(context: context)
        
        //peel away variables
        
        guard let name = record[CarConstants.nameKey] as? String,
            
            let make = record[CarConstants.makeKey] as? String,
            
            let model = record[CarConstants.modelKey] as? String,
            
            let year = record[CarConstants.yearKey] as? String,
            
            let vin = record[CarConstants.vinKey] as? String,
            
            let engine = record[CarConstants.engineKey] as? String,
            
            let ownerName = record[CarConstants.ownerNameKey] as? String,
            
            let altitude =  record[CarConstants.altitudeKey] as? Double,
            
            let lattitude = record[CarConstants.lattitudeKey] as? Double,
            
            let longitude = record[CarConstants.longitudeKey] as? Double
            
            else {return}
        
        //build from record
        
        self.name = name
        
        self.model = model
        
        self.make = make
        
        self.year = year
        
        self.vin = vin
        
        self.engine = engine
        
        self.ownerName = ownerName
        
        self.altitude = altitude
        
        self.lattitude = lattitude
        
        self.longitude = longitude
        
        self.recordID = record.recordID.recordName
        
    }
}

extension CKRecord{
    
    convenience init?(car:Car){
        
        guard let recordid = car.recordID else {return nil}
        
        let recordIDinFormat = CKRecord.ID(recordName: recordid)
        
        self.init(recordType:CarConstants.CarTypeKey, recordID:recordIDinFormat)
        
        self.setValue(car.name, forKey: CarConstants.nameKey)
        
        self.setValue(car.make, forKey: CarConstants.makeKey)
        
        self.setValue(car.model, forKey: CarConstants.modelKey)
        
        self.setValue(car.year, forKey: CarConstants.yearKey)
        
        self.setValue(car.vin, forKey: CarConstants.vinKey)
        
        self.setValue(car.engine, forKey: CarConstants.engineKey)
        
        self.setValue(car.ownerName, forKey: CarConstants.engineKey)
        
        self.setValue(car.altitude, forKey: CarConstants.altitudeKey)
        
        self.setValue(car.lattitude, forKey: CarConstants.lattitudeKey)
        
        self.setValue(car.longitude, forKey: CarConstants.longitudeKey)
        
    }
}
