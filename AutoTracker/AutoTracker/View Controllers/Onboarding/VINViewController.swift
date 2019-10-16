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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vinTextField.delegate = self
        yearTextField.delegate = self
    }
    
    @IBAction func helpButtonTapped(_ sender: Any) {
        presentVINAlert()
    }
    
    
    // MARK: - FUNCTIONS
    func presentVINAlert() {
        let alertController = UIAlertController(title: "VIN", message: "- A VIN is used to identify basic information about your vehicle \n- It is usually 17 characters long \n-It can be found by opening the driver's door and looking at the door post (where the door latches when it is closed)", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Enter VIN", style: .default)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
    
    // MARK: - NAVIGATION
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toVINResultsVC" {
            if let destinationVC = segue.destination as? VINResultsViewController {
                destinationVC.carParts = carParts
                destinationVC.CarJson = CarJson
            }
        }
    }
    
}

extension VINViewController: UITextFieldDelegate {

//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        return true
//    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        if let vin = vinTextField.text,
            let year = yearTextField.text {
        carParts.year = year
            CarController.shared.retrieveCarDetailsWith(vin: vin, year: year) { (CarJson, error) in
                DispatchQueue.main.async {
                    self.CarJson = CarJson
                    self.performSegue(withIdentifier: "toVINResultsVC", sender: nil)
                }
            }
        }

        return true
    }
}




