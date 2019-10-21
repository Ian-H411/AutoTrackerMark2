//
//  VINViewController.swift
//  AutoTracker
//
//  Created by Sam LoBue on 10/15/19.
//  Copyright © 2019 Ian Hall. All rights reserved.
//

import UIKit

class VINViewController: UIViewController {
    
    // MARK: - OUTLETS
    @IBOutlet weak var vinTextField: UITextField!
    @IBOutlet weak var yearTextField: UITextField!
    
    // MARK: - PROPERTIES
    var vin: String?
    var carParts: Car = Car(context: CoreDataStack.context)
    var CarJson: CarJson?
    
    // MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        vinTextField.delegate = self
    }
    
    @IBAction func helpButtonTapped(_ sender: Any) {
        presentVINAlert()
    }
    
    
    // MARK: - FUNCTIONS
    //////UIAlertCotroller to inform a user what a VIN should look like
    func presentVINAlert() {
        let alertController = UIAlertController(title: "VIN", message: "- A VIN is used to identify basic information about your vehicle \n- It is usually 17 characters long \n-It can be found by opening the driver's door and looking at the door post (where the door latches when it is closed)", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Enter VIN", style: .default)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
    
//    func carTireAnimation() {
//
//        let tireAnimation = TireAnimation(frame: CGRect(x: 0, y: 0, width: 100, height: 100), image: #imageLiteral(resourceName: "loadingIcon"))
//        view.addSubview(TireAnimation)
//
//    }
    
    // MARK: - NAVIGATION
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toVINResultsVC" {
            if let destinationVC = segue.destination as? VINResultsViewController {
                destinationVC.carParts = carParts
                destinationVC.CarJson = CarJson
            }
        }
    }
    
    @IBAction func tappedToDismissKeyboard(_ sender: Any) {
        vinTextField.resignFirstResponder()
    }
}

extension VINViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let vin = vinTextField.text {
            CarController.shared.retrieveCarDetailsWith(vin: vin, year: "") { (CarJson, error) in
                DispatchQueue.main.async {
                    self.CarJson = CarJson
                    let tireAnimation = TireAnimation(frame: CGRect(x: 0, y: 0, width: 500, height: 500), image: #imageLiteral(resourceName: "loadingIcon"))
                    
                    self.view.addSubview(tireAnimation)
                    tireAnimation.startAnimating()
                    self.performSegue(withIdentifier: "toVINResultsVC", sender: nil)
                }
            }
        }
        return true
    }
}




