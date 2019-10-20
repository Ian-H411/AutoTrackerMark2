//
//  CarController.swift
//  AutoTracker
//
//  Created by Ian Hall on 10/4/19.
//  Copyright © 2019 Ian Hall. All rights reserved.
//

import UIKit
import CoreData
import CloudKit
class CarController {
    
    //MARK: - VARIABLES AND INITIALIZERS
    
    
    //singleton
    static let shared = CarController()
    
    
    
    // source of Truth
    var garage: [Car]?
    
    //secondary source of truth
    var selectedCar: Car?

    
    //database location
    //    let privateDB = CKContainer.default().privateCloudDatabase
    
    //initializer to fetch
    init() {
        let fetchRequest:NSFetchRequest<Car> = Car.fetchRequest()
        
        let moc = CoreDataStack.context
        
        garage = (try? moc.fetch(fetchRequest)) ?? []
        
        guard let carFirst = garage?.first else {return}
        
        selectedCar = carFirst
    }

    
    //MARK: -CRUD
    
    ///Creates a car and adds it to the garage, saves any changes to the context and then returns the car as well
    func addACar(name:String, make:String, model:String, year:String, engine:String, ownerName:String,odometer:Double) -> Car {
        let newCar = Car(name: name, make: make, model: model, year: year, engine: engine, ownerName: ownerName, odometer: odometer, photoData: nil)
        garage?.append(newCar)
        saveChangesToPersistentStoreOnly()
        return newCar
    }
    
    
    ///Updates an existing car with new details then performs a save
    func carupdate(name:String, make:String, model:String, year:String, engine:String, ownerName:String, car:Car) {
        car.name = name
        car.make = make
        car.model = model
        car.year = year
        car.engine = engine
        car.ownerName = ownerName
        saveChangesToPersistentStoreOnly()
    }
    
    ///Updates the cars odometer in a simpler form then carUpdate
    func updateOdometer(car: Car, odometer: Double, completion: @escaping (Bool) -> Void) {
        car.odometer = odometer
        completion(true)
        saveChangesToPersistentStoreOnly()
    }
    
    ///Updates a cars photo
    func updatePhoto(car: Car, photo: UIImage, completion: @escaping (Bool) -> Void) {
        car.photo = photo
        completion(true)
        saveChangesToPersistentStoreOnly()
    }
    
    ///use this so we dont have to constantly find the cars maintenance
    func organizeAndReturnMaintainenceList() -> [Maintanence] {
        guard let car = selectedCar else {return[]}
        let allMaintenance = car.upcomingMaintanence?.allObjects as? [Maintanence] ?? []
        let maintenance = allMaintenance.filter { (main) -> Bool in
            if !main.isReceipt{
                return true
            } else {
                return false
            }
        }
        let sortedMaintenance = maintenance.sorted { (lhs, rhs) -> Bool in
            guard let leftDate = lhs.dueOn,
                let rhsDate = rhs.dueOn
                else {return false}
            return leftDate.compare(rhsDate) == .orderedAscending
        }
        return sortedMaintenance
    }
    
    /// pulls the currently selected cars gas receipts and then returns them
    func organizeAndReturnReceipts() -> [Maintanence] {
        guard let car = selectedCar else { return [] }
        let maintenance = car.upcomingMaintanence?.allObjects as? [Maintanence] ?? []
        let receipts = maintenance.filter({$0.isReceipt})
        return receipts
    }
    
    /// removes the car and also removes it from the persistent store
    func removeCarFromGarage(car:Car){
        if let moc = car.managedObjectContext{
            moc.delete(car)
            saveChangesToPersistentStoreOnly()
        }
    }
    
    ///adds a maintenance history reminder to the currently selected car
    func addMaintenance(car:Car, message:String?, maintanence:String ,date: Date, image: UIImage?, price: String) -> Maintanence{
        let newMain = Maintanence(duedate: date, maintanenceRequiered: maintanence, details: message ?? "", car: car, price:price)
        newMain.photo = image
        car.upcomingMaintanence?.adding(newMain)
        saveChangesToPersistentStoreOnly()
        return newMain
    }
    
    ///Adds a gas receipt to the currently selected car
    func addReceipt(car: Car, miles: Double, gallons: String, cost: String, image: UIImage?) {
        let miles = Double(miles)
        let receipt = Maintanence(car: car, price: cost, odometerStamp: miles, details: gallons, isReceipt: true)
        receipt.photo = image
        car.upcomingMaintanence?.adding(receipt)
        saveChangesToPersistentStoreOnly()
    }
    
    /// modifies a maintenance entry
    func modifyMaintenance(maintenance:Maintanence, date:Date, newTitle:String, details:String?, image: UIImage?) {
        maintenance.dueOn = date
        maintenance.maintanenceRequired = newTitle
        maintenance.details = details
        maintenance.photo = image
        saveChangesToPersistentStoreOnly()
    }
    
    ///Toggles whether or not the maintenance reminder is complete and then saves
    func toggleMaintenanceReminder(maintenance: Maintanence) {
        maintenance.isComplete.toggle()
        saveChangesToPersistentStoreOnly()
    }

    ///Deletes the inputted maintenance
    func deleteMaintenance(maintenance:Maintanence) {
        if let moc = maintenance.managedObjectContext{
            moc.delete(maintenance)
            saveChangesToPersistentStoreOnly()
        }
    }
    
    ///modify the maintenance odometer
    func modifyMaintenance(odometer:Double, maintenance: Maintanence) {
        maintenance.odometerStamp = odometer
        saveChangesToPersistentStoreOnly()
    }
    
    /// modify the maintenance price
    func modifyMaintenance(price:String, maintenance: Maintanence) {
        maintenance.price = price
        saveChangesToPersistentStoreOnly()
    }
    
    ///modify the maintenance photo
    func modifyMaintenance(photo:UIImage, maintenance: Maintanence) {
        maintenance.photo = photo
        saveChangesToPersistentStoreOnly()
    }
    
    ///retrieve a car from the api if no year is provided simpley pass in a empty string
    func retrieveCarDetailsWith(vin:String, year:String, completion: @escaping (CarJson?, Error?) -> Void) {
        //base url
        guard var baseURL = URL(string: "https://vpic.nhtsa.dot.gov/api/vehicles/decodevinvalues/") else {completion(nil, nil);return}
        
        //add vin
        baseURL.appendPathComponent(vin)
        guard var componenets = URLComponents(string: baseURL.absoluteString) else {completion(nil,nil);print("invalidUrl");return}
        //add year
        let queryItems = [URLQueryItem(name: "format", value: "json"), URLQueryItem(name: "modelyear", value: year)]
        componenets.queryItems = queryItems
        guard let finalURL = componenets.url else {completion(nil,nil);print("invalidUrl");return}
        print(finalURL)
        
        //begin my url session
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
                print(data)
                let results = try decoder.decode(CarResultsHead.self, from: data)
                print(results)
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
   
    
    //MARK: -SAVE

    
    ///save function that only performs locally
    private func saveChangesToPersistentStoreOnly(){
        if CoreDataStack.context.hasChanges{
            try? CoreDataStack.context.save()
        }
    }
    
    
}
