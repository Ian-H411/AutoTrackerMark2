//
//  TextFieldStyle.swift
//  AutoTracker
//
//  Created by Ian Hall on 10/7/19.
//  Copyright © 2019 Ian Hall. All rights reserved.
//

import UIKit

class TextFieldStyle: UITextField {
    override func awakeFromNib() {
        super.awakeFromNib()
        addBorder(color: .black, width: 2, bg: .lightGray)
        addCornerRadius()
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
