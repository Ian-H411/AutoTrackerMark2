//
//  HomeViewController.swift
//  AutoTracker
//
//  Created by Sam LoBue on 10/7/19.
//  Copyright © 2019 Ian Hall. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - OUTLETS
    
    @IBOutlet weak var carImageView: UIImageView!
    @IBOutlet weak var carNameLabel: UILabel!
    @IBOutlet weak var averageMPGLabel: UILabel!
    @IBOutlet weak var lifetimeMilesLabel: UILabel!
    @IBOutlet weak var thisTankLabel: UILabel!
    @IBOutlet weak var mostRecentMaintenanceLabel: AutoTrackerLabel!
    
    @IBOutlet weak var nextMostRecentMaintenanceLabel: AutoTrackerLabel!
    @IBOutlet weak var noMaintenanceLabel: AutoTrackerLabel!
    
    // MARK: - PROPERTIES
    var myCar: Car? {
        didSet {
            updateViews()
        }
    }
    
    var scheduledMaintenance: [Maintanence]? {
        if let maintenance = myCar?.upcomingMaintanence?.allObjects as? [Maintanence] {
            return maintenance
        } else {
            return []
        }
    }
    
    var labels: [UILabel] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.myCar = CarController.shared.selectedCar
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - ACTIONS
   
    
    
    // MARK: - FUNCTIONS
    
    func updateViews() {
        guard let myCar = myCar else { return }
        
//        updateMaintenanceLabels()
        carImageView.image = myCar.photo ?? UIImage(named: "car")
        carNameLabel.text = myCar.name ?? "Car Name"
        lifetimeMilesLabel.text = String(describing: myCar.odometer)
        lifetimeMilesLabel.layer.cornerRadius = 8
        averageMPGLabel.layer.cornerRadius = 8
        thisTankLabel.layer.cornerRadius = 8
        mostRecentMaintenanceLabel.isHidden = true
        nextMostRecentMaintenanceLabel.isHidden = true
        
        guard let scheduledMaintenance = scheduledMaintenance else { return }
        mostRecentMaintenanceLabel.isHidden = false
        mostRecentMaintenanceLabel.text = "No Maintenance Items For This Car"
        if scheduledMaintenance.count <= 2 {
            guard let maintenanceRequired = scheduledMaintenance.first?.maintanenceRequired, let dueOn = scheduledMaintenance.first?.dueOn else { return }
            mostRecentMaintenanceLabel.isHidden = false
            mostRecentMaintenanceLabel.text = maintenanceRequired + " | " + DateHelper.shared.stringForMaintenanceDate(date: dueOn)
            guard let secondMaintenanceRequired = scheduledMaintenance[1].maintanenceRequired, let secondDueOn = scheduledMaintenance[1].dueOn else { return }
            nextMostRecentMaintenanceLabel.isHidden = false
            nextMostRecentMaintenanceLabel.text = secondMaintenanceRequired + " | " + DateHelper.shared.stringForMaintenanceDate(date: secondDueOn)
        } else if scheduledMaintenance.count == 0 {
            
        }
    }
    
//    func makeMaintenanceLabels() {
//        guard let scheduledMaintenance = scheduledMaintenance else { return }
//        self.labels.removeAll()
//        for _ in scheduledMaintenance {
//            labels.append(AutoTrackerLabel())
//        }
//    }
//
//    func updateMaintenanceLabels() {
//        guard let scheduledMaintenance = scheduledMaintenance else { return }
//
//        makeMaintenanceLabels()
//        var j = 0
//        if j <= 1 {
//            for i in labels {
//                i.text = scheduledMaintenance[j].details! + "|" + DateHelper.shared.stringForMaintenanceDate(date: scheduledMaintenance[j].dueOn!)
//                mutableMaintenanceStackView.addArrangedSubview(i)
//                j += 1
//            }
//        }
//    }

    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
