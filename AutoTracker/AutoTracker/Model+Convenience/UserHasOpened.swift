//
//  UserHasOpened.swift
//  AutoTracker
//
//  Created by Sam LoBue on 10/16/19.
//  Copyright © 2019 Ian Hall. All rights reserved.
//

import Foundation
import CoreData

extension UserHasOpened {
    
    convenience init(marker: String = "userExists", context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        self.marker = marker
    }
}
