//
//  CoreDataStack.swift
//  AutoTracker
//
//  Created by Sam LoBue on 10/2/19.
//  Copyright © 2019 DjangoEarnhardt. All rights reserved.
//

import Foundation
import CoreData

enum CoreDataStack {
    static let container: NSPersistentContainer = {
        let container = NSPersistentCloudKitContainer(name: "AutoTracker1.1")
        
        // Creates a store description for local store
        let localStoreLocation = getLocalCDDir()
        let localStoreDescription = NSPersistentStoreDescription(url: localStoreLocation)
        localStoreDescription.configuration = "Local"
        
        // Creates a store description for CloudKit-backed local store
        let cloudStoreLocation = getLocalCloudDir()
        let cloudStoreDescription = NSPersistentStoreDescription(url: cloudStoreLocation)
        cloudStoreDescription.configuration = "Cloud"
        
        // Sets the container options on the cloud store
        cloudStoreDescription.cloudKitContainerOptions = NSPersistentCloudKitContainerOptions(containerIdentifier: "iCloud.AutoTracker1.1")
        
        // Updates the container's list of store descriptions
        container.persistentStoreDescriptions = [
            cloudStoreDescription,
            localStoreDescription
        ]
        
        container.loadPersistentStores(completionHandler: {
            (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error.userInfo)")
            }
        })
        return container
    }()
    static var context: NSManagedObjectContext { return
        container.viewContext }
}

func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}

func getLocalCDDir() -> URL {
    let path = getDocumentsDirectory().appendingPathComponent("CD")
    return path as URL
}

func getLocalCloudDir() -> URL {
    let path = getDocumentsDirectory().appendingPathComponent("CLOUD")
    return path as URL
}
