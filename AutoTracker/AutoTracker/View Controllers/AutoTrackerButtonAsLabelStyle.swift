//
//  AutoTrackerButtonAsLabelStyle.swift
//  AutoTracker
//
//  Created by Ian Hall on 10/7/19.
//  Copyright © 2019 Ian Hall. All rights reserved.
//

import UIKit

class AutoTrackerButtonAsLabel: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addBorder(color: .black, width: 2, bg: .lightGray)
   
        addCornerRadius()
        
    }

    func addBorder(color: UIColor, width: CGFloat, bg: UIColor) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
        self.layer.backgroundColor = UIColor.red.cgColor
    }
    
    func addCornerRadius() {
        self.layer.cornerRadius = frame.width / 32
    }
}

class AutoTrackerButtonGrayBG: AutoTrackerButtonAsLabel {

    override func addBorder(color: UIColor, width: CGFloat, bg: UIColor) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
        self.layer.backgroundColor = UIColor.lightGray.cgColor
        
    }
}

class AutoTrackerButtonGreen: AutoTrackerButtonAsLabel {
    
    override func addBorder(color: UIColor, width: CGFloat, bg: UIColor) {
        self.layer.backgroundColor = UIColor.autoGreen.cgColor
        self.setTitleColor(.white, for: .normal)
    }
}
