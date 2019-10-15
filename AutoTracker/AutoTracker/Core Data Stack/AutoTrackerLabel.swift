//
//  AutoTrackerLabel.swift
//  AutoTracker
//
//  Created by Sam LoBue on 10/4/19.
//  Copyright © 2019 Ian Hall. All rights reserved.
//

import UIKit

class AutoTrackerLabel: UILabel {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        chooseFont(to: FontNames.system)
        addBorder(color: .black, width: 2, bg: .lightGray)
        addCornerRadius()
    }
    
    func chooseFont(to fontName: String) {
//        let size = font.pointSize
        self.font = UIFont(name: fontName, size: 18)
    }
    
    func addBorder(color: UIColor, width: CGFloat, bg: UIColor) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
        self.layer.backgroundColor = bg.cgColor
    }
    
    func addCornerRadius() {
        self.layer.cornerRadius = frame.width / 32
    }
}

class AutoTrackerLabelHeadline: UILabel {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.font = UIFont(name: FontNames.nunitoRegular, size: 18)
    }
}

class AutoTrackerLabelDetail: UILabel {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.font = UIFont(name: FontNames.nunitoRegular, size: 14)
    }
}

class AutoTrackerGreenLabel: UILabel {
        
    override func awakeFromNib() {
        super.awakeFromNib()
        self.font = UIFont(name: FontNames.nunitoRegular, size: 18)
        self.textColor = .autoGreen
    }
}

class AutoTrackerLabelGreenBG: AutoTrackerLabel {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.textColor = .white
        addBorder(color: .autoGreen, width: 2, bg: .autoGreen)
    }
}

class AutoTrackerSmallGrayLabel: UILabel {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.font = UIFont(name: FontNames.nunitoRegular, size: 14)
        self.textColor = .autoGray
    }
}

class AutoTrackerGreenBorderLabel: AutoTrackerLabel {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addBorder(color: .autoGreen, width: 2, bg: .white)
        self.textColor = .autoGreen
    }
}
