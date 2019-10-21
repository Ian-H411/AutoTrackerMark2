//
//  RecordViewController.swift
//  AutoTracker
//
//  Created by Sam LoBue on 10/7/19.
//  Copyright © 2019 Ian Hall. All rights reserved.
//

import UIKit

class RecordViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if CarController.shared.selectedCar == nil {
            enterCarAlert()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    // MARK: - FUNCTIONS
    func enterCarAlert() {
        let alertController = UIAlertController(title: "No vehicle in My Garage. Please add a car to your Garage.", message: nil, preferredStyle:  .alert)
        let action = UIAlertAction(title: "Okay", style: .default, handler: { (_) in
            self.tabBarController?.selectedIndex = 2
        })
        alertController.addAction(action)
        present(alertController, animated: true)
    }

    func backHome() {
        guard let homeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "mainVC") as? CustomTabBarController else { return }
        homeVC.modalPresentationStyle = .fullScreen
        self.present(homeVC, animated: true)
    }
}
