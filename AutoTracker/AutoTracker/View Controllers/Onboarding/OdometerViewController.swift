//
//  OdometerViewController.swift
//  AutoTracker
//
//  Created by Sam LoBue on 10/7/19.
//  Copyright © 2019 Ian Hall. All rights reserved.
//

import UIKit

class OdometerViewController: UIViewController {
    
    // MARK: - OUTLETS
    @IBOutlet weak var odometerPicker: UIPickerView!
    
    // MARK: - PROPERTIES
    var odometer = ["0","1","2","3","4","5","6","7","8","9"]
    var carParts: Car?
    
    var randomOdometer: [Int] = [9,8,7,6,7,8,9]
       
    
    // MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        odometerPicker.delegate = self
        odometerPicker.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setPickerViewToCarValue(intArray: randomOdometer)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        UIView.animate(withDuration: 1) {
            self.setPickerViewToCarValue(intArray: [0,0,0,0,0,0,0])
        }
       
    }
    
    // MARK: - ACTIONS
    @IBAction func saveButtonTapped(_ sender: Any) {
        let odometer = odometerResults()
        if let _ = carParts {
            carParts?.odometer = Double(odometer)
            self.performSegue(withIdentifier: "toCarNameVC", sender: nil)
        } else {
            carParts = CarController.shared.addACar(name: "", make: "", model: "", year: "", engine: "", ownerName: "", odometer: Double(odometer))
            self.performSegue(withIdentifier: "toCarNameVC", sender: nil)
        }
    }
    
    @IBAction func skipButtonTapped(_ sender: Any) {
        if let car = carParts {
            CarController.shared.removeCarFromGarage(car: car)
            CarController.shared.selectedCar = nil
            performSegue(withIdentifier: "toMainVC", sender: nil)
        } else {
            CarController.shared.selectedCar = nil
            performSegue(withIdentifier: "toMainVC", sender: nil)
        }
    }
    
    // MARK: - HELPER FUNCTIONS
    func odometerResults() -> Int {
        var placeholder: [Int] = []
        for component in 0..<odometerPicker.numberOfComponents {
            let number = odometerPicker.selectedRow(inComponent: component)
            placeholder.append(number)
        }
        let odometer = placeholder.reduce(0, {$0*10 + $1})
        return odometer
    }
    
    
    func setPickerViewToCarValue(intArray: [Int]) {
        UIView.animate(withDuration: 2) {
            self.odometerPicker.selectRow(intArray[0], inComponent: 0, animated: true)
            self.odometerPicker.selectRow(intArray[1], inComponent: 1, animated:  true)
            self.odometerPicker.selectRow(intArray[2], inComponent: 2, animated: true)
            self.odometerPicker.selectRow(intArray[3], inComponent: 3, animated: true)
            self.odometerPicker.selectRow(intArray[4], inComponent: 4, animated: true)
            self.odometerPicker.selectRow(intArray[5], inComponent: 5, animated: true)
            self.odometerPicker.selectRow(intArray[6], inComponent: 6, animated: true)
        }
        
    }
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toCarNameVC" {
            if let destinationVC = segue.destination as? CarNameViewController {
                destinationVC.carParts = carParts
            }
        }
    }
}

extension OdometerViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        7
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
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
}


