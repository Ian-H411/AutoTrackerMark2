//
//  MyGarageTableViewCell.swift
//  AutoTracker
//
//  Created by Sam LoBue on 10/4/19.
//  Copyright © 2019 Ian Hall. All rights reserved.
//

import UIKit

protocol MyGarageTableViewCellDelegate: UIView{
    func carSelectionButtonTapped(_ sender: MyGarageTableViewCell)
}

class MyGarageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var carButton: UIView!
    
    
    weak var delegate:MyGarageTableViewCellDelegate?
    
    
    @IBAction func carButtonTapped(_ sender: Any) {
    }
    
    func updateCell(car:Car){
        
    }
}
