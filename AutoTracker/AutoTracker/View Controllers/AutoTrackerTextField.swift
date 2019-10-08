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
        self.layer.borderColor = UIColor.black.cgColor
//        self.borderStyle = .roundedRect // ?
        self.backgroundColor = UIColor.lightGray
    }
}
