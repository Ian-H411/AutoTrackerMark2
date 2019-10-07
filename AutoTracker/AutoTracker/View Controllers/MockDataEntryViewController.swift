//
//  MockDataEntryViewController.swift
//  AutoTracker
//
//  Created by Ian Hall on 10/7/19.
//  Copyright © 2019 Ian Hall. All rights reserved.
//

import UIKit

class MockDataEntryViewController: UIViewController {

    @IBOutlet weak var carNameTextField: UITextField!
    
    @IBOutlet weak var ownerTextFIeld: UITextField!
    
    @IBOutlet weak var makeTextField: UITextField!
    
    @IBOutlet weak var modelTextField: UITextField!
    
    @IBOutlet weak var engineTypeTextField: UITextField!
    
    @IBOutlet weak var yearTextField: UITextField!
    
    @IBOutlet weak var vinTextField: UITextField!
    
    @IBOutlet weak var odometerTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let carNameText = carNameTextField.text,
            let ownerNameText = ownerTextFIeld.text,
            let makeText = makeTextField.text,
            let modelText = modelTextField.text,
            let engineText = engineTypeTextField.text,
            let yearText = yearTextField.text,
            let vinText = vinTextField.text,
            let odometerText = odometerTextField.text
            else {print("something was nil");return}
        
        CarController.shared.addACar(name: carNameText, make: makeText, model: modelText, year: yearText, vin: vinText, engine: engineText, ownerName: ownerNameText, odometer: Double(odometerText)!)
        
    }
    
   
}
