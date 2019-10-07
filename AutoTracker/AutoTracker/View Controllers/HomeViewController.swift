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
    
    
    @IBOutlet weak var mutableMaintenanceStackView: UIStackView!
    
    // MARK: - PROPERTIES
    var myCar: Car? {
        didSet {
            updateViews()
        }
    }
    
    var scheduledMaintenance: [Maintanence]? {
        didSet {
            
        }
    }
    
    var labels: [UILabel] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
        
    }
    
    // MARK: - ACTIONS

    
    
    // MARK: - FUNCTIONS

    func updateViews() {
        guard let myCar = myCar else { return }

        updateMaintenanceLabels()
//        carImageView.image = myCar.image
        carNameLabel.text = myCar.name ?? "Car Name"
        lifetimeMilesLabel.text = String(describing: myCar.odometer) 

        
    }
    
    
    func makeMaintenanceLabels() {
        guard let scheduledMaintenance = scheduledMaintenance else { return }
        self.labels.removeAll()
        for _ in scheduledMaintenance {
            labels.append(AutoTrackerLabel())
        }
    }
    
    func updateMaintenanceLabels() {
        guard let scheduledMaintenance = scheduledMaintenance else { return }
        
        makeMaintenanceLabels()
        var j = 0
        if j <= 1 {
        for i in labels {
            i.text = scheduledMaintenance[j].details! + "|" + DateHelper.shared.stringForMaintenanceDate(date: scheduledMaintenance[j].dueOn!)
            mutableMaintenanceStackView.addArrangedSubview(i)
            j += 1
        }
        } else {
            return
        }
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
