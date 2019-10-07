//
//  MyGarageTableViewCell.swift
//  AutoTracker
//
//  Created by Sam LoBue on 10/4/19.
//  Copyright © 2019 Ian Hall. All rights reserved.
//

import UIKit

protocol MyGarageTableViewCellDelegate{
    func carSelectionButtonTapped(_ sender: MyGarageTableViewCell)
}

class MyGarageTableViewCell: UITableViewCell {
    

    @IBOutlet weak var carButton: UIButton!
    
    var carInCell:Car?
    
    
    var delegate:MyGarageTableViewCellDelegate?
    
    
    @IBAction func carButtonTapped(_ sender: Any) {
         delegate?.carSelectionButtonTapped(self)
    }
    
    func updateCell(car:Car){
        guard let carname = car.name else {return}
        carButton.setTitle(carname, for:.normal )
        carInCell = car
    }
}
