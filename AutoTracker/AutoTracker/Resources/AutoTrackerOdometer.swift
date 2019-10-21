//
//  AutoTrackerOdometer.swift
//  AutoTracker
//
//  Created by Sam LoBue on 10/18/19.
//  Copyright © 2019 Ian Hall. All rights reserved.
//

import UIKit

class AutoTrackerOdometer: UIPickerView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addStyle()
    }
    
    func addStyle() {
        self.layer.cornerRadius = 12
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.backgroundColor = UIColor.black.cgColor
        self.setValue(UIColor.white, forKey: "textColor")
    }
}
