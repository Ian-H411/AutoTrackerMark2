//
//  ReceiptController.swift
//  AutoTracker
//
//  Created by Sam LoBue on 10/4/19.
//  Copyright © 2019 Ian Hall. All rights reserved.
//

import UIKit
import CoreData
import CloudKit

class ReceiptController {
    
    // MARK: - VARIABLES AND INITIALIZERS
    
    // singleton
    static let shared = ReceiptController()
    
    // source of Truth
    var receipts: [Receipt] {
        
        let moc = CoreDataStack.context
        
        let fetchRequest: NSFetchRequest<Receipt> = Receipt.fetchRequest()
        
        return (try? moc.fetch(fetchRequest)) ?? []
    }
    
    //database location
//    let privateDB = CKContainer.default().privateCloudDatabase
    
    // MARK: - CRUD
    
    // CREATE
    func addReceiptWith(name: String, timestamp: Date, photo: UIImage?, total: String, ppg: String) {
        let timestamp = Date()
        let newReceipt = Receipt(name: name, timestamp: timestamp, total: total, ppg: ppg, context: CoreDataStack.context)
        newReceipt.photo = photo
        saveToPersistentStoreOnly()
//        saveReceiptToPersistentStoreAndCloud(receipt: newReceipt)
    }
    
    // READ
    
    // retrieve from cloud?
    // TODO: - Send to cloud if CD doesn't do this
    
    // UPDATE
//    private func saveReceiptToPersistentStoreAndCloud(receipt: Receipt) {
//        // save locally first
//        let moc = CoreDataStack.context
//        do {
//            try moc.save()
//        } catch {
//            print("there was an error in \(#function) :\(error) : \(error.localizedDescription)")
//        }
//        // create record and push to cloud
//        let record = CKRecord(receipt: receipt)
//        privateDB.save(record) { (receipt, error) in
//            if let error = error {
//                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
//                return
//            }
//        }
//    }
    
    private func saveToPersistentStoreOnly() {
        if CoreDataStack.context.hasChanges {
            try? CoreDataStack.context.save()
        }
    }
        
    // DELETE
    func deleteReceipt(receipt: Receipt) {
        
        // delete locally
        let moc = CoreDataStack.context
        moc.delete(receipt)
        
        // delete in cloud
//        guard let recordIDAsString = receipt.recordID else { return }
//        let deletion = CKRecord.ID(recordName: recordIDAsString)
//        let operation = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: [deletion])
//        privateDB.add(operation)
//    }
}
}

