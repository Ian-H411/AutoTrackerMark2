//
//  MaintenanceViewController.swift
//  AutoTracker
//
//  Created by Ian Hall on 10/7/19.
//  Copyright © 2019 Ian Hall. All rights reserved.
//

import UIKit

class MaintenanceViewController: UIViewController {

    
    //MARK: - OUTLETS
    
    @IBOutlet weak var upcomingMaintenance1: UILabel!
    
    @IBOutlet weak var upcomingMaintenance2: UILabel!
    
    //MARK: - LIFECYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //MARK: - HELPERS
    
    func setUpUI(){
        guard let car = CarController.shared.selectedCar else {return}
        guard let maintenanceList = car.upcomingMaintanence else {return}
        if let maintentance = maintenanceList.allObjects.first as? Maintanence {
            guard let date = maintentance.dueOn else {return}
            let dateAsString = DateHelper.shared.stringForMaintenanceDate(date: date)
            upcomingMaintenance1.text = "\(maintentance.maintanenceRequired ?? "") | \(dateAsString)"
        }
    }

}
