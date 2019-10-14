//
//  MaintainenceDetailTableViewCell.swift
//  AutoTracker
//
//  Created by Ian Hall on 10/7/19.
//  Copyright © 2019 Ian Hall. All rights reserved.
//

import UIKit

class MaintainenceDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var cellLabel: AutoTrackerLabel!
    @IBOutlet weak var vendorLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    
    
    var scheduledMaintenance: Maintanence? {
        didSet {
            updateViews()
        }
    }
    
    func updateViews() {
        guard let vendor = scheduledMaintenance?.maintanenceRequired, let details = scheduledMaintenance?.details, let dueDate = scheduledMaintenance?.dueOn else { return }
        vendorLabel.text = "\(vendor) | \(details)"
        dueDateLabel.text = DateHelper.shared.stringForMaintenanceDate(date: dueDate)
    }
}
