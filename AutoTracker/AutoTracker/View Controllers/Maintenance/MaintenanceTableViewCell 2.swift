//
//  MaintenanceTableViewCell.swift
//  AutoTracker
//
//  Created by Ian Hall on 10/14/19.
//  Copyright © 2019 Ian Hall. All rights reserved.
//

import UIKit

class MaintenanceTableViewCell: UITableViewCell {

//MARK: -OUTLETS
    @IBOutlet weak var entryNameLabel: UILabel!
    
    @IBOutlet weak var entryTypeLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var cashTotalLabel: UILabel!
    
    @IBOutlet weak var completionButton: UIButton!
    
    //MARK: -VARIABLES
    
    
    
    //MARK: - ACTIONS
    
    @IBOutlet weak var completedButtonTapped: UIButton!
    
    
    //MARK: -HELPERS
    
    func update(maintenance:Maintanence){
        entryNameLabel.text = maintenance.maintanenceRequired
        entryTypeLabel.text = maintenance.details
        let dateAsString = DateHelper.shared.stringForMaintenanceDate(date: maintenance.dueOn ?? Date())
        dateLabel.text = dateAsString
        
    }
    
    
}
