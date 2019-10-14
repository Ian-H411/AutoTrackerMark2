//
//  ReceiptTableViewCell.swift
//  AutoTracker
//
//  Created by Sam LoBue on 10/12/19.
//  Copyright © 2019 Ian Hall. All rights reserved.
//

import UIKit

class ReceiptTableViewCell: UITableViewCell {

    // MARK: - OUTLETS
    @IBOutlet weak var vendorLabel: AutoTrackerLabel!
    @IBOutlet weak var totalLabel: AutoTrackerSmallGrayLabel!
    @IBOutlet weak var dateLabel: AutoTrackerSmallGrayLabel!
    @IBOutlet weak var ppgLabel: AutoTrackerSmallGrayLabel!
    
    
    // MARK: - PROPERTIES
    var receipt: Receipt? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - FUNCTIONS
    func updateViews() {
        guard let receipt = receipt,
            let name = receipt.name,
            let total = receipt.total,
            let date = receipt.timestamp,
            let ppg = receipt.ppg else { return }
        vendorLabel.text = name
        totalLabel.text = "$\(total) total"
        dateLabel.text = DateHelper.shared.stringForMaintenanceDate(date: date)
        ppgLabel.text = "$\(ppg)/gal"
    }
    
}
