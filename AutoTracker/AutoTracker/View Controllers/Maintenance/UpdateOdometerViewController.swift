//
//  UpdateOdometerViewController.swift
//  AutoTracker
//
//  Created by Ian Hall on 10/14/19.
//  Copyright © 2019 Ian Hall. All rights reserved.
//

import UIKit

class UpdateOdometerViewController: UIViewController {
    //MARK: - OUTLETS
    
    @IBOutlet weak var carNameLabel: AutoTrackerLabelGreenBG!
    
    @IBOutlet weak var odometerPicker: UIPickerView!
    
    @IBOutlet weak var savedLabel: AutoTrackerLabelGreenBG!
    
    //MARK: -VARIABLES
    
    var maintenance: Maintanence?
    
    var odometer = ["0","1","2","3","4","5","6","7","8","9"]
    
    
    
    //MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetUP()
        setPickerViewToCarValue()
    }
    
    //MARK: - Helpers
    func setPickerViewToCarValue(){
        guard let car = CarController.shared.selectedCar else {return}
        var odomenterAsStringArray = Array("\(Int(car.odometer))")
        print(odomenterAsStringArray)
        while odomenterAsStringArray.count < 7 {
            odomenterAsStringArray.insert("0", at: 0)
        }
        print(odomenterAsStringArray)
        UIView.animate(withDuration: 2) {
            self.odometerPicker.selectRow(Int(String(odomenterAsStringArray[0])) ?? 0, inComponent: 0, animated: true)
            self.odometerPicker.selectRow(Int(String(odomenterAsStringArray[1])) ?? 0, inComponent: 1, animated:  true)
            self.odometerPicker.selectRow(Int(String(odomenterAsStringArray[2])) ?? 0, inComponent: 2, animated: true)
            self.odometerPicker.selectRow(Int(String(odomenterAsStringArray[3])) ?? 0, inComponent: 3, animated: true)
            self.odometerPicker.selectRow(Int(String(odomenterAsStringArray[4])) ?? 0, inComponent: 4, animated: true)
            self.odometerPicker.selectRow(Int(String(odomenterAsStringArray[5])) ?? 0, inComponent: 5, animated: true)
            self.odometerPicker.selectRow(Int(String(odomenterAsStringArray[6])) ?? 0, inComponent: 6, animated: true)
        }
        
    }
    func warnUsersOfChange(){
        guard let car = CarController.shared.selectedCar else {return}
        let alertController = UIAlertController(title: "Change \(car.name ?? "") miles?", message: "This will update the odometer on the car are you sure?", preferredStyle: .alert)
        let okayButton = UIAlertAction(title: "Update", style: .default) { (_) in
            guard let car = CarController.shared.selectedCar else {return}
            guard let main = self.maintenance else {return}
            let odo = Double(self.odometerResults())
                   CarController.shared.updateOdometer(car: car, odometer: odo) { (_) in
                       
                   }
                   CarController.shared.modifyMaintenance(odometer: odo, maintenance: main)
                   UIView.animate(withDuration: 2) {
                       self.savedLabel.isHidden = false
                   }
            self.navigationController?.popToRootViewController(animated: true)
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alertController.addAction(okayButton)
        alertController.addAction(cancelButton)
        self.present(alertController,animated: true)
    }
    
    func initialSetUP(){
        guard let car = CarController.shared.selectedCar else {return}
        carNameLabel.text = "update \(car.name ?? "")'s odometer"
        savedLabel.isHidden = true
        odometerPicker.delegate = self
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
    
    //MARK: - Actions
    
    @IBAction func skipButtonTapped(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
       warnUsersOfChange()
    }
    
    
    
    
}
extension UpdateOdometerViewController: UIPickerViewDataSource, UIPickerViewDelegate{
    
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
