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
                     photoData: Data?,
                     context: NSManagedObjectContext = CoreDataStack.context) {
        
        self.init(context: context)
        self.name = name
        self.timestamp = timestamp
        self.photoData = photoData
        
    }
}

extension CKRecord {
    
    convenience init(receipt: Receipt) {
        self.init(recordType: Constants.ReceiptTypeKey)
        
        self.setValue(receipt.name, forKey: Constants.nameKey)
        self.setValue(receipt.timestamp, forKey: Constants.timestampKey)
        self.setValue(receipt.photoData, forKey: Constants.photoKey)
    }
}
