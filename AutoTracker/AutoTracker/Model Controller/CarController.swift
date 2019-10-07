//
//  CarController.swift
//  AutoTracker
//
//  Created by Ian Hall on 10/4/19.
//  Copyright © 2019 Ian Hall. All rights reserved.
//

import Foundation
import CoreData
import CloudKit
class CarController{
    
    //MARK: - VARIABLES AND INITIALIZERS
    
    
    //singleton
    let shared = CarController()
    
    // source of Truth
    var garage: NSFetchedResultsController<Car>
    
    //database location
    let privateDB = CKContainer.default().privateCloudDatabase
    
    //initializer to fetch
    init(){
        let fetchRequest:NSFetchRequest<Car> = Car.fetchRequest()
        
        let alphaSort = NSSortDescriptor(key: "model", ascending: false)
        
        fetchRequest.sortDescriptors = [alphaSort]
        
        let resultsController: NSFetchedResultsController<Car> = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: nil, cacheName: nil)
        garage = resultsController
        
        do {
            try garage.performFetch()
        } catch  {
            print("there was an error in \(#function) :\(error) : \(error.localizedDescription)")
        }
    }
    //MARK: -CRUD
    
    //Create a car
    func addACar(name:String, make:String, model:String, year:String, vin:String, engine:String, ownerName:String,odometer:Double, photoData: Data?){
        let newCar = Car(name: name, make: make, model: model, year: year, vin: vin, engine: engine, ownerName: ownerName, odometer: odometer, photoData: photoData)
        saveCarToPersistentStoreAndCloud(car: newCar)
        
    }
    
    //update car
    func carupdate(name:String, make:String, model:String, year:String, vin:String, engine:String, ownerName:String, car:Car){
        
        //update details
        car.name = name
        car.make = make
        car.model = model
        car.year = year
        car.vin = vin
        car.engine = engine
        car.ownerName = ownerName
        
        //save changes
        saveChangesToPersistentStoreOnly()
        
        //create a record of the modified car
        guard let modifiedCar = CKRecord(car: car) else {return}
        
        //create my operation
        let operation = CKModifyRecordsOperation(recordsToSave: [modifiedCar], recordIDsToDelete: nil)
        operation.savePolicy = .changedKeys
        operation.qualityOfService = .userInitiated
        
        //perform my cloudpush
        privateDB.add(operation)
        
    }
    
    //delete a car
    func removeCarFromGarage(car:Car){
        if let moc = car.managedObjectContext{
            
            //delete locally first
            moc.delete(car)
            saveChangesToPersistentStoreOnly()
            
            //delete in cloud
            guard let recordIDAsString = car.recordID else {return}
            let recordIdToDelete = CKRecord.ID(recordName: recordIDAsString)
            let operation = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: [recordIdToDelete])
            privateDB.add(operation)
        }
        
    }
    
    //add a maintenance reminder
    func addMaintenanceReminder(car:Car, message:String, maintanence:String ,date: Date){
        //TODO: - SET UP ABILITY TO ADD NOTIFICATION
        let newMain = Maintanence(duedate: date, maintanenceRequiered: maintanence, details: message, car: car)
        car.upcomingMaintanence?.adding(newMain)
        saveChangesToPersistentStoreOnly()
    }
    
    
    //retrieve a car from the api
    func retrieveCarDetailsWith(vin:String, year:String, completion: @escaping (CarJson?, Error?) -> Void){
        var baseURL = URL(fileURLWithPath: "https://vpic.nhtsa.dot.gov/api/vehicles/decodevin/")
        baseURL.appendPathComponent(vin)
        guard var componenets = URLComponents(string: baseURL.absoluteString) else {completion(nil,nil);print("invalidUrl");return}
        let queryItems = [URLQueryItem(name: "format", value: "json"), URLQueryItem(name: "modelyear", value: year)]
        componenets.queryItems = queryItems
        guard let finalURL = componenets.url else {completion(nil,nil);print("invalidUrl");return}
        let request = URLRequest(url: finalURL)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error{
                print("there was an error in \(#function) :\(error) : \(error.localizedDescription)")
                completion(nil,error)
                return
            }
            guard let data = data else{completion(nil,nil);print("data was nil");return}
            
            do{
                let decoder = JSONDecoder()
                let results = try decoder.decode(CarResultsHead.self, from: data)
                guard let carJson = results.Results.first else {return}
                completion(carJson, nil)
                return
            } catch {
                print("there was an error in \(#function) :\(error) : \(error.localizedDescription)")
                completion(nil,nil)
                return
            }
            
        }.resume()
    }
    
    //retrievecarsfromcloud
    func retrieveOnlineGarageAndSave(completion: @escaping (Bool) -> Void){
        
        //retrieve all records from the users private
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: CarConstants.CarTypeKey, predicate: predicate)
        privateDB.perform(query, inZoneWith: nil) { (recordsOptional, error) in
            if let error = error{
                print("there was an error in \(#function) :\(error) : \(error.localizedDescription)")
                completion(false)
                return
            }
            guard let carRecords = recordsOptional else {completion(false);return}
            for record in carRecords {
                guard let _ = Car(record: record) else {completion(false);return}
            }
            
            self.saveChangesToPersistentStoreOnly()
            completion(true)
            return
        }
    }
    
    //MARK: -SAVE
    private func saveCarToPersistentStoreAndCloud(car: Car){
        //save locally first
        let moc = CoreDataStack.context
        do {
            try moc.save()
        } catch  {
            print("there was an error in \(#function) :\(error) : \(error.localizedDescription)")
        }
        //create record and push to cloud
        guard let record = CKRecord(car: car) else {return}
        privateDB.save(record) { (record, error) in
            if let error = error{
                print("there was an error in \(#function) :\(error) : \(error.localizedDescription)")
                return
            }
            
        }
    }
    
    //save function that only performs locally
    private func saveChangesToPersistentStoreOnly(){
        if CoreDataStack.context.hasChanges{
            try? CoreDataStack.context.save()
        }
    }
    
}
