//
//  CustomTabBarController.swift
//  AutoTracker
//
//  Created by Sam LoBue on 10/10/19.
//  Copyright © 2019 Ian Hall. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    @IBInspectable var defaultIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedIndex = defaultIndex
    }
    
}
