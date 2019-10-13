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
        addTextStyle(color: .black, font: UIFont(name: FontNames.nunitoRegular, size: 18)!)
    }

    func addBorder(color: UIColor, width: CGFloat, bg: UIColor) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
        self.layer.backgroundColor = UIColor.red.cgColor
    }
    
    func addCornerRadius() {
        self.layer.cornerRadius = frame.width / 32
    }
    
    func addTextStyle(color: UIColor, font: UIFont) {
        self.setTitleColor(color, for: .normal)
        self.titleLabel?.font = font
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
    
    override func addTextStyle(color: UIColor, font: UIFont) {
        self.setTitleColor(.white, for: .normal)
        self.titleLabel?.font = UIFont(name: FontNames.nunitoRegular, size: 18)
    }
}
