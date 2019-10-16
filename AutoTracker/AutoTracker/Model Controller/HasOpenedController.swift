//
//  HasOpenedController.swift
//  AutoTracker
//
//  Created by Sam LoBue on 10/16/19.
//  Copyright © 2019 Ian Hall. All rights reserved.
//

import Foundation
import CoreData

class HasOpenedController {
    
    static let shared = HasOpenedController()
    
    func checkIfModelExists() -> Bool {
        
        let fetchRequest:NSFetchRequest<UserHasOpened> = UserHasOpened.fetchRequest()
        let moc = CoreDataStack.context
        do {
            let _ = try moc.fetch(fetchRequest)
            
            return true
        } catch {
            let error = error
            print(error.localizedDescription)
            createModel()
            return false
        }
        
    }
    
    private func createModel() {
        let _ = UserHasOpened()
        saveToPersistentStore()
    }
    
    private func saveToPersistentStore() {
        if CoreDataStack.context.hasChanges {
            try? CoreDataStack.context.save()
        }
        
    }
}
