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
    
    
    // MARK: - LIFECYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        odometerPicker.delegate = self
        odometerPicker.dataSource = self
        odometerPicker.layer.borderWidth = 5
        odometerPicker.layer.cornerRadius = 12
        odometerPicker.layer.borderColor = UIColor.black.cgColor
        odometerPicker.layer.backgroundColor = UIColor.black.cgColor
        odometerPicker.setValue(UIColor.white, forKey: "textColor")
        
    }
    
    // MARK: - ACTIONS
    @IBAction func updateButtonTapped(_ sender: Any) {
        
        let odometer = odometerResults()
        if let car = CarController.shared.selectedCar {
        }
        guard let car = CarController.shared.selectedCar else { return }
        CarController.shared.updateOdometer(car: car, odometer: Double(odometer)) { (success) in
            if success {
                DispatchQueue.main.async {
                    
                    UIView.animate(withDuration: 0.5) {
                        self.dismiss(animated: true)
                    }
                }
            }
        }
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    func odometerResults() -> Int {
        var placeholder: [Int] = []
        for component in 0..<odometerPicker.numberOfComponents {
            let number = odometerPicker.selectedRow(inComponent: component)
            placeholder.append(number)
        }
        let odometer = placeholder.reduce(0, {$0*10 + $1})
        return odometer
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

//extension OdometerViewController: UITextFieldDelegate {
//
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        print("tapped")
//    }
//
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        return false
//    }
//}
