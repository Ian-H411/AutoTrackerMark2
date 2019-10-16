//
//  GetStartedViewController.swift
//  AutoTracker
//
//  Created by Sam LoBue on 10/15/19.
//  Copyright © 2019 Ian Hall. All rights reserved.
//

import UIKit

class GetStartedViewController: UIViewController {

   // MARK: - OUTLETS
    
    // MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - ACTIONS
    @IBAction func helpButtonTapped(_ sender: Any) {
        presentVINAlert()
    }
    
    @IBAction func skipButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    
    // MARK: - FUNCTIONS
    func presentVINAlert() {
        let alertController = UIAlertController(title: "VIN", message: "- A VIN is used to identify basic information about your vehicle \n- It is usually 17 characters long \n-It can be found by opening the driver's door and looking at the door post (where the door latches when it is closed)", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Enter VIN", style: .default)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
}

extension GetStartedViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        guard let vin = vinEntryTextField.text else { return }
        performSegue(withIdentifier: "toOdometerVC", sender: nil)
        return true
    }
    
}
