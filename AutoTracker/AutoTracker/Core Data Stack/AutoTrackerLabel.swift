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

class AutoTrackerDetailLabel: UILabel {
    
    func chooseFont(to fontName: String) {
        let size = 14
        self.font = UIFont(name: fontName, size: CGFloat(size))
    }
}

class AutoTrackerGreenBorderLabel: AutoTrackerLabel {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addBorder(color: .autoGreen, width: 2, bg: .white)
        self.textColor = .autoGreen
    }
}
