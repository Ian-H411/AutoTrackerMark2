//
//  AddCarTableViewController.swift
//  AutoTracker
//
//  Created by Sam LoBue on 10/9/19.
//  Copyright © 2019 Ian Hall. All rights reserved.
//

import UIKit

protocol Alerts: class {
    func notANumberAlert()
    func notAVINAlert()
}

class AddCarTableViewController: UITableViewController {

    // MARK: - OUTLETS
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ownerTextField: UITextField!
    @IBOutlet weak var makeTextField: UITextField!
    @IBOutlet weak var modelTextField: UITextField!
    @IBOutlet weak var engineTextField: UITextField!
    @IBOutlet weak var yearTextField: UITextField!
    @IBOutlet weak var vinTextField: UITextField!
    @IBOutlet weak var odometerPicker: UIPickerView!
    

    // MARK: - PROPERTIES
    var odometer = ["0","1","2","3","4","5","6","7","8","9"]
    
    // MARK: - LIFECYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        yearTextField.delegate = self
        odometerPicker.delegate = self
        odometerPicker.dataSource = self
    }

    // MARK: - ACTIONS
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let name = nameTextField.text,
            !name.isEmpty,
            let owner = ownerTextField.text,
            !owner.isEmpty,
            let make = makeTextField.text,
            !make.isEmpty,
            let model = modelTextField.text,
            !model.isEmpty,
            let year = yearTextField.text,
            !year.isEmpty,
            let engine = engineTextField.text,
            !engine.isEmpty,
            let vin = vinTextField.text,
            !vin.isEmpty
            else { return }
        
        let cleanVIN = cleanVin(vin: vin)
        
        if cleanVIN.contains("I") || cleanVIN.contains("O") || cleanVIN.count < 11 && cleanVIN.count > 17 {
            notAVINAlert()
            vinTextField.text = ""
            return
        }
        
        if year.count != 4 {
            notAValidYear()
            yearTextField.text = ""
            return
        }
        
        let odometer = odometerResults()
        
        CarController.shared.addACar(name: name, make: make, model: model, year: year, vin: cleanVIN, engine: engine, ownerName: owner, odometer: Double(odometer), photoData: nil)
        navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: - Functions
    
    func notANumberAlert() {
        let alertController = UIAlertController(title: "Please enter a valid year", message: nil, preferredStyle: .actionSheet)
        let ok = UIAlertAction(title: "Ok", style: .default)
        alertController.addAction(ok)
        present(alertController, animated: true)
    }
    
    func notAVINAlert() {
        let alertController = UIAlertController(title: "Please enter a valid VIN", message: nil, preferredStyle: .actionSheet)
        let ok = UIAlertAction(title: "Ok", style: .default)
        alertController.addAction(ok)
        present(alertController, animated: true)
    }
    
    func notAValidYear() {
        let alertController = UIAlertController(title: "Please enter a valid year", message: nil, preferredStyle: .actionSheet)
        let ok = UIAlertAction(title: "Ok", style: .default)
        alertController.addAction(ok)
        present(alertController, animated: true)
    }
    
    func cleanVin(vin: String) -> String {
        let clean = vin.components(separatedBy: " ").joined().uppercased()
        let cleaner = clean.components(separatedBy: CharacterSet.punctuationCharacters).joined()
        return cleaner
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
    
    // MARK: - Table view data source



    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension AddCarTableViewController: UITextFieldDelegate {
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField == yearTextField, let text = textField.text, !text.isNumeric {
            self.notANumberAlert()
            return false
        }
        return true
    }
}

extension String {
    var isNumeric : Bool {
        return Double(self) != nil
    }
}

extension AddCarTableViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
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
