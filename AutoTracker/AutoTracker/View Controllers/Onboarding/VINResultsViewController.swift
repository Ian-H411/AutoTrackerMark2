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
        
        updateTextFields()
    }
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        
        buildCarParts()
        performSegue(withIdentifier: "toOdometerVC", sender: nil)
    }
    
    // MARK: - FUNCTIONS
    
    func updateTextFields() {
        
        guard let CarJson = CarJson else { return }
        makeTextField.text = CarJson.make
        modelTextField.text = CarJson.model
        yearTextField.text = CarJson.year
        engineTextField.text = CarJson.engine
    }
    
    func buildCarParts() {
        carParts?.make = makeTextField.text
        carParts?.model = modelTextField.text
        carParts?.year = yearTextField.text
        carParts?.engine = engineTextField.text
    }
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toOdometerVC" {
            if let destinationVC = segue.destination as? OdometerViewController {
                destinationVC.carParts = carParts
            }
        }
    }
}
