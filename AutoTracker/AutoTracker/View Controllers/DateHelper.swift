//
//  DateHelper.swift
//  AutoTracker
//
//  Created by Sam LoBue on 10/7/19.
//  Copyright © 2019 Ian Hall. All rights reserved.
//

import Foundation

class DateHelper {
    
    static let shared = DateHelper()
    
    private init() {}
    
    let dateFormatter = DateFormatter()
    
    func stringForMaintenanceDate(date: Date) -> String {
        dateFormatter.dateStyle = .medium
        let dateString = dateFormatter.string(from: date)
        
        return dateString
    }
}

