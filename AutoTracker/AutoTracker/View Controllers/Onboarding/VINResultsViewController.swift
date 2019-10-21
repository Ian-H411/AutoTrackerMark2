//
//  VINResultsViewController.swift
//  AutoTracker
//
//  Created by Sam LoBue on 10/16/19.
//  Copyright © 2019 Ian Hall. All rights reserved.
//

import UIKit

class VINResultsViewController: UIViewController {
    
    // MARK: - OUTLETS
    @IBOutlet weak var makeTextField: TextFieldStyle!
    @IBOutlet weak var modelTextField: TextFieldStyle!
    @IBOutlet weak var yearTextField: TextFieldStyle!
    @IBOutlet weak var engineTextField: TextFieldStyle!
    
    // MARK: - PROPERTIES
    var carParts: Car?
    var CarJson: CarJson?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeTextField.delegate = self
        modelTextField.delegate = self
        yearTextField.delegate = self
        engineTextField.delegate = self
        addDoneButtonOnKeyboard(textField: yearTextField)
        updateTextFields()
    }
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        buildCarParts()
        performSegue(withIdentifier: "toOdometerVC", sender: nil)
    }
    
    @IBAction func skipButtonTapped(_ sender: Any) {
        guard let car = carParts else { return }
        CarController.shared.removeCarFromGarage(car: car)
        CarController.shared.selectedCar = nil
        performSegue(withIdentifier: "toMainVC", sender: nil)
    }
    
    @IBAction func dismissKeyboardTapped(_ sender: Any) {
        makeTextField.resignFirstResponder()
        modelTextField.resignFirstResponder()
        yearTextField.resignFirstResponder()
        engineTextField.resignFirstResponder()
    }
    
    // MARK: - FUNCTIONS
    ///Update the screen to represent the results from the fetched VIN
    func updateTextFields() {
        guard let CarJson = CarJson else { return }
        makeTextField.text = CarJson.make
        modelTextField.text = CarJson.model
        yearTextField.text = CarJson.year
        engineTextField.text = CarJson.engine
    }
    
    func addDoneButtonOnKeyboard(textField: UITextField) {
           let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
           doneToolbar.barStyle = .default
           let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
           let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
           let items = [flexSpace, done]
           doneToolbar.items = items
           doneToolbar.sizeToFit()
           textField.inputAccessoryView = doneToolbar
       }
       
       @objc func doneButtonAction(){
           yearTextField.resignFirstResponder()
       }
    ///Applies carJson Struct properties to carParts Car Model
    func buildCarParts() {
        carParts?.make = makeTextField.text
        carParts?.model = modelTextField.text
        carParts?.year = yearTextField.text
        carParts?.engine = engineTextField.text
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toOdometerVC" {
            if let destinationVC = segue.destination as? OdometerViewController {
                destinationVC.carParts = carParts
            }
        }
    }
}

extension VINResultsViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
