//
//  FinalCheckForVinViewController.swift
//  AutoTracker
//
//  Created by Ian Hall on 10/10/19.
//  Copyright © 2019 Ian Hall. All rights reserved.
//
//  Picker Code made by Sam

import UIKit

class FinalCheckForVinViewController: UIViewController {
    
    
    
    
    //MARK: - OUTLETS
    
    @IBOutlet weak var addCarToGarageButton: AutoTrackerButtonAsLabel!
    
    @IBOutlet weak var odometerPicker: UIPickerView!
    
    @IBOutlet weak var ownerTextField: UITextField!
    
    @IBOutlet weak var ownerTextLabel: UILabel!
    
    @IBOutlet weak var nicknameTextField: UITextField!
    
    @IBOutlet weak var nicknameLabel: UILabel!
    
    @IBOutlet weak var carSummaryLabel: UILabel!
    
    @IBOutlet weak var headerLabel: UILabel!
    
    
    //MARK: -VARIABLES
    
    var odometer = ["0","1","2","3","4","5","6","7","8","9"]
    
    var car: CarJson?
    
    var vin: String?
    
    
    //MARK: -LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        initialUISetUP()
        odometerPicker.delegate = self
        odometerPicker.dataSource = self
        odometerPicker.layer.borderWidth = 5
        odometerPicker.layer.cornerRadius = 12
        odometerPicker.layer.borderColor = UIColor.black.cgColor
        odometerPicker.layer.backgroundColor = UIColor.black.cgColor
        odometerPicker.setValue(UIColor.white, forKey: "textColor")
        ownerTextField.delegate = self
        nicknameTextField.delegate = self
       
    }
    
    
    //MARK: - HELPERS
    
    func initialUISetUP(){
        guard let car = car else {return}
        guard let vin = vin else {return}
        let text = "Make: \(car.make)  |  Model: \(car.model) \n Year: \(car.year) | Engine: \(car.engine) \n Vin:\(vin)"
        carSummaryLabel.text = text
    }
    
    
    func presentFinalCheckAlert(){
        let alert = UIAlertController(title: "Everything look alright", message: "just checking", preferredStyle: .alert)
        let cancelButton = UIAlertAction(title: "cancel", style: .destructive, handler: nil)
        let looksGoodButton = UIAlertAction(title: "Looks Good", style: .default) { (_) in
            DispatchQueue.main.async {
                self.popViewAndSaveCar()
            }
            
        }
        alert.addAction(cancelButton)
        alert.addAction(looksGoodButton)
        self.present(alert, animated: true)
    }
    func popViewAndSaveCar(){
        guard let carJson = car
            else {return}
        guard let name = nicknameTextField.text,
            let owner = ownerTextField.text
            else {return}
        let make = carJson.make
        let model = carJson.model
        let year = carJson.year
        let engine  = carJson.engine
        let odometer = odometerResults()
        let _ = CarController.shared.addACar(name: name, make: make, model: model, year: year, engine: engine, ownerName: owner, odometer: Double(odometer))
        navigationController?.popToRootViewController(animated: true)
    }
    
    func presentEmptyNameAlert(){
        let alert = UIAlertController(title: "Missing Fields", message: "Looks like you may have forgotten something check and try again", preferredStyle: .alert)
        let okayBUtton = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alert.addAction(okayBUtton)
        self.present(alert, animated: true)
    }
    
    func odometerResults() -> Int {
        var placeholder: [Int] = []
        for component in 0..<odometerPicker.numberOfComponents {
            let number = odometerPicker.selectedRow(inComponent: component)
            placeholder.append(number)
        }
        let odometer = placeholder.reduce(0, {$0*10 + $1})
        return odometer
    }
    
    
    //MARK: - ACTIONS
    
    @IBAction func addCarToMyGarageButtonTapped(_ sender: Any) {
        guard let nickname = nicknameTextField.text
            else {return}
        if nickname.isEmpty{
            presentEmptyNameAlert()
            return
        }
        presentFinalCheckAlert()
    }
    
    
    
}
extension FinalCheckForVinViewController: UIPickerViewDataSource, UIPickerViewDelegate{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 7
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.odometer.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        return
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(row)
    }
    
    
}
extension FinalCheckForVinViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
