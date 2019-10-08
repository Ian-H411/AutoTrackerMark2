//
//  Receipt+Convenience.swift
//  AutoTracker
//
//  Created by Sam LoBue on 10/2/19.
//  Copyright © 2019 DjangoEarnhardt. All rights reserved.
//

import CloudKit
import CoreData
import UIKit

extension Receipt {
    
    convenience init(name: String,
                     timestamp: Date = Date(),
                     total: String,
                     ppg: String,
                     context: NSManagedObjectContext = CoreDataStack.context) {
        
        self.init(context: context)
        self.name = name
        self.timestamp = timestamp
        self.total = total
        self.ppg = ppg
        self.recordID = UUID().uuidString
    }
    
    convenience init? (record: CKRecord, context: NSManagedObjectContext = CoreDataStack.context) {
        
        self.init(context: context)
        
        guard let name = record[ReceiptConstants.nameKey] as? String,
        
            let timestamp = record[ReceiptConstants.timestampKey] as? Date,
        
            let photoData = record[ReceiptConstants.photoKey] as? Data
            else { return nil }

        self.name = name
        self.timestamp = timestamp
        self.photoData = photoData
    }
}

extension CKRecord {
    
    convenience init(receipt: Receipt) {
        self.init(recordType: ReceiptConstants.ReceiptTypeKey)
        
        self.setValue(receipt.name, forKey: ReceiptConstants.nameKey)
        self.setValue(receipt.timestamp, forKey: ReceiptConstants.timestampKey)
        self.setValue(receipt.photoData, forKey: ReceiptConstants.photoKey)
    }
}

extension Receipt {
    
    var photo: UIImage? {
        get {
            guard let photoData = photoData else { return nil }
            return UIImage(data: photoData)
        } set {
            photoData = newValue?.jpegData(compressionQuality: 0.5)
        }
    }
}
