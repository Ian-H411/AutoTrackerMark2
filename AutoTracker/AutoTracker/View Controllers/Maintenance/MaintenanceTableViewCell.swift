//
//  MaintenanceTableViewCell.swift
//  AutoTracker
//
//  Created by Ian Hall on 10/14/19.
//  Copyright © 2019 Ian Hall. All rights reserved.
//

import UIKit

protocol MaintenanceTableViewCellDelegate {
    func buttonTapped(_ sender: MaintenanceTableViewCell)
}

class MaintenanceTableViewCell: UITableViewCell {
    
    //MARK: -OUTLETS
    @IBOutlet weak var entryNameLabel: UILabel!
    
    @IBOutlet weak var entryTypeLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var cashTotalLabel: UILabel!
    
    @IBOutlet weak var completionButton: UIButton!
    
    @IBOutlet weak var receiptImageView: UIButton!
    
    //MARK: -VARIABLES
    
    var delegate: MaintenanceTableViewCellDelegate?
    
    //MARK: - ACTIONS
    
    @IBAction func CompletionButtonTapped(_ sender: Any) {
        delegate?.buttonTapped(self)
    }
    
    //MARK: -HELPERS
    
    func update(maintenance:Maintanence){
        entryNameLabel.text = maintenance.maintanenceRequired
        entryTypeLabel.text = maintenance.details
        let dateAsString = DateHelper.shared.stringForMaintenanceDate(date: maintenance.dueOn ?? Date())
        dateLabel.text = dateAsString
        if maintenance.isComplete{
            if let image = maintenance.photo{
                imageView?.image = image
                completionButton.isHidden = true
            } else {
                completionButton.setTitle("Complete", for: .normal)
            }
        }
    }
    
    
}
