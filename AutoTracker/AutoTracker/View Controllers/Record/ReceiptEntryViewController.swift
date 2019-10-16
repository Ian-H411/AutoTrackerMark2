//
//  ReceiptEntryViewController.swift
//  AutoTracker
//
//  Created by Sam LoBue on 10/14/19.
//  Copyright © 2019 Ian Hall. All rights reserved.
//

import UIKit

class ReceiptEntryViewController: UIViewController {
    
    // MARK: - OUTLETS
    @IBOutlet weak var milesButton: AutoTrackerButtonGreenBG!
    @IBOutlet weak var gallonsButton: AutoTrackerButtonGreenBG!
    @IBOutlet weak var costButton: AutoTrackerButtonGreenBG!
    @IBOutlet weak var saveFillUpButton: AutoTrackerButtonGreenBG!
    @IBOutlet weak var reusableTextField: UITextField!
    @IBOutlet weak var updateButton: AutoTrackerButtonGreenBG!
    @IBOutlet weak var resultsLabel: AutoTrackerLabelGreenBG!
    @IBOutlet weak var resultsButton: UIButton!
    
    
    
    // MARK: - PROPERTIES
    
    var milesTapped = 0
    var gallonsTapped = 0
    var costTapped = 0
    var miles: Double = 0
    var gallons: Double = 0
    
    
    
    
    // MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        reusableTextField.delegate = self
        updateButton.alpha = 0.0
        reusableTextField.alpha = 0.0
        resultsLabel.isHidden = true
        resultsLabel.alpha = 0.0
        resultsButton.isHidden = true
        resultsButton.alpha = 0.0
        
    }
    
    // MARK: - ACTIONS
    
    @IBAction func milesButtonTapped(_ sender: Any) {
        
        UIView.animate(withDuration: 0.5) {
            self.gallonsButton.alpha = 0.0
            self.milesButton.isHidden = true
            self.milesButton.alpha = 0.0
            self.costButton.alpha = 0.0
            self.saveFillUpButton.isHidden = true
            self.saveFillUpButton.alpha = 0.0
            self.costButton.isHidden = true
            
        }
        
        UIView.animate(withDuration: 0.5) {
            self.entryFieldsAppear()
            
        }
        milesTapped += 1
        
    }
    @IBAction func gallonsButtonTapped(_ sender: Any) {
        
        UIView.animate(withDuration: 0.5) {
            self.milesButton.alpha = 0.0
            self.milesButton.isHidden = true
            self.gallonsButton.alpha = 0.0
            self.saveFillUpButton.alpha = 0.0
            self.costButton.alpha = 0.0
            self.gallonsButton.isHidden = true
            self.costButton.isHidden = true
        }
        
        UIView.animate(withDuration: 0.5) {
            self.entryFieldsAppear()
        }
        gallonsTapped += 1
        
    }
    @IBAction func costButtonTapped(_ sender: Any) {
        
        UIView.animate(withDuration: 0.5) {
            self.milesButton.alpha = 0.0
            self.milesButton.isHidden = true
            self.gallonsButton.alpha = 0.0
            self.costButton.alpha = 0.0
            self.costButton.isHidden = true
            self.saveFillUpButton.alpha = 0.0
            self.saveFillUpButton.isHidden = true
            
        }
        
        UIView.animate(withDuration: 0.5) {
            self.entryFieldsAppear()
        }
        costTapped += 1
        
    }
    @IBAction func updateButtonTapped(_ sender: Any) {
        
        UIView.animate(withDuration: 1) {
            self.entryFieldsFadeAway()
            self.backToNormal()
            
        }
        guard let entryText = reusableTextField.text, !entryText.isEmpty else { return }
        if milesTapped > 0 {
            miles = Double(entryText) ?? 0
            milesButton.setTitle("\(entryText) miles", for: .normal)
            reusableTextField.text = ""
        } else if gallonsTapped > 0 {
            gallons = Double(entryText) ?? 0
            gallonsButton.setTitle("\(entryText) gallons", for: .normal)
            reusableTextField.text = ""
        } else if costTapped > 0 {
            costButton.setTitle("$\(entryText)", for: .normal)
            reusableTextField.text = ""
        }
        resetTappedTally()
    }
    
    
    @IBAction func saveFillUpButtonTapped(_ sender: Any) {
        
        guard let car = CarController.shared.selectedCar,
            
            let gallons = gallonsButton.titleLabel?.text,
            let cost = costButton.titleLabel?.text else { return }
        
        if gallons == "Gallons" || cost == "Cost" || miles == 0 {
            
            emptyFieldsAlert()
            
        } else {
            
            CarController.shared.addReceipt(car: car, miles: miles, gallons: gallons, cost: cost)
            
            CarController.shared.updateOdometer(car: car, odometer: miles) { (_) in
                
            }
            let mpg = milesPerGallon(miles: self.miles, gallon: self.gallons)
            resultsLabel.text = "You got \(round((100 * mpg) / 100)) miles per gallon this trip!"
            
            UIView.animate(withDuration: 0.5) {
                self.milesButton.alpha = 0.0
                self.milesButton.isHidden = true
                self.gallonsButton.alpha = 0.0
                self.gallonsButton.isHidden = true
                self.costButton.alpha = 0.0
                self.costButton.isHidden = true
                self.resultsLabel.alpha = 1.0
                self.resultsLabel.isHidden = false
                self.saveFillUpButton.alpha = 0.0
                //        self.saveFillUpButton.isHidden = true
                //            self.updateButton.isHidden = true
                self.saveFillUpButton.isEnabled = false
                self.reusableTextField.isHidden = true
                self.resultsButton.isHidden = false
                self.resultsButton.alpha = 1.0
                self.view.bringSubviewToFront(self.resultsButton)
            }
        }
    }
    
    @IBAction func resultsButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - FUNCTIONS
    func entryFieldsAppear() {
        updateButton.alpha = 1.0
        reusableTextField.alpha = 1.0
    }
    
    func entryFieldsFadeAway() {
        updateButton.alpha = 0.0
        reusableTextField.alpha = 0.0
    }
    
    func backToNormal() {
        milesButton.alpha = 1.0
        milesButton.isHidden = false
        gallonsButton.alpha = 1.0
        gallonsButton.isHidden = false
        costButton.alpha = 1.0
        costButton.isHidden = false
        saveFillUpButton.alpha = 1.0
        saveFillUpButton.isHidden = false
    }
    
    func resetTappedTally() {
        milesTapped = 0
        gallonsTapped = 0
        costTapped = 0
    }
    
    func milesPerGallon(miles: Double, gallon: Double) -> Double {
        return (miles / gallon)
    }
    
    func emptyFieldsAlert() {
        let alertController = UIAlertController(title: "You have empty Receipt fields", message: "Please enter a value for each of the fields to proceed", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Okay", style: .default)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
}
extension ReceiptEntryViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
