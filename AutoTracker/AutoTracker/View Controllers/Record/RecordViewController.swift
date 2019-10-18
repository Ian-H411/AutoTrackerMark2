//
//  RecordViewController.swift
//  AutoTracker
//
//  Created by Sam LoBue on 10/7/19.
//  Copyright © 2019 Ian Hall. All rights reserved.
//

import UIKit

class RecordViewController: UIViewController {

    // MARK: - PROPERTIES
//    var enteredGasEntry: Bool = false
    
    // MARK: - LIFECYCLE
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(true)
//        if enteredGasEntry == true {
//
//            backHome()
//            enteredGasEntry = false
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if CarController.shared.selectedCar == nil {
            enterCarAlert()
        }
    }
    
    @IBAction func enterGasButtonTapped(_ sender: Any) {
//        enteredGasEntry = true
    }
    

    // MARK: - FUNCTIONS
    
    func enterCarAlert() {
        let alertController = UIAlertController(title: "No vehicle in My Garage, fill up won't be saved.", message: nil, preferredStyle:  .alert)
        let action = UIAlertAction(title: "Okay", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
    
    
    func backHome()
    {
            
        guard let homeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "mainVC") as? CustomTabBarController else { return }
        homeVC.modalPresentationStyle = .fullScreen
        self.present(homeVC, animated: true)

    }

}
