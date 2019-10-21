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
        //manual segue based on ifapploaded before
        //pop if has been loaded, and segue if not
        if isAppAlreadyLaunchedOnce() {
            self.presentingViewController?.dismiss(animated: true)
        } else {
            self.performSegue(withIdentifier: "toMainVC", sender: nil)
        }
    }
    
    
    // MARK: - FUNCTIONS
    ///UIAlertCotroller to inform a user what a VIN should look like
    func presentVINAlert() {
        let alertController = UIAlertController(title: "VIN", message: "- A VIN is used to identify basic information about your vehicle \n- It is usually 17 characters long \n-It can be found by opening the driver's door and looking at the door post (where the door latches when it is closed)", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Enter VIN", style: .default)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
    ///Sets a Bool letting AT know if the app has been launched before, and skip the Onboarding entirely.
    func isAppAlreadyLaunchedOnce()->Bool{
        let defaults = UserDefaults.standard
        if let _ = defaults.string(forKey: "isAppAlreadyLaunchedOnce"){
            return true
        }else{
            defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
            return false
        }
    }
}

extension GetStartedViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        performSegue(withIdentifier: "toOdometerVC", sender: nil)
        return true
    }
}
