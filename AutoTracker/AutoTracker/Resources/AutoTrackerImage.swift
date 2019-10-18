//
//  AutoTrackerImage.swift
//  AutoTracker
//
//  Created by Sam LoBue on 10/18/19.
//  Copyright © 2019 Ian Hall. All rights reserved.
//

import UIKit

class AutoTrackerImage: UIImageView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addBorder()
    }
    
    func addBorder() {
        self.layer.borderWidth = 3
        self.layer.borderColor = UIColor.autoGreen.cgColor
        self.layer.cornerRadius = 20
    }
}
