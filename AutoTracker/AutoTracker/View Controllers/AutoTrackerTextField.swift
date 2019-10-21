//
//  AutoTrackerTextField.swift
//  AutoTracker
//
//  Created by Sam LoBue on 10/7/19.
//  Copyright © 2019 Ian Hall. All rights reserved.
//

import UIKit

class AutoTrackerTextField: UITextField {
    override func awakeFromNib() {
        super.awakeFromNib()
        addBorderAndBG()
    }
    
    func addBorderAndBG() {
        self.layer.borderWidth = 2
        self.layer.cornerRadius = 10
        self.layer.borderColor = UIColor.autoGreen.cgColor
        self.backgroundColor = UIColor.clear
        self.layer.masksToBounds = true
    }
}
