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
    
    
    // MARK: - PROPERTIES
    
    var milesTapped = 0
    var gallonsTapped = 0
    var costTapped = 0
    
    var milesValue = "" {
        didSet {
            if self.milesValue != "" {
//                milesButton.setTitle(self.milesValue, for: .normal)
            }
        }
    }
    
    // MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateButton.alpha = 0.0
        reusableTextField.alpha = 0.0
        
        // Do any additional setup after loading the view.
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
        print("Miles tapped: \(milesTapped)")
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
        print("Gallons tapped: \(gallonsTapped)")
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
        print("Cost tapped: \(costTapped)")
    }
    @IBAction func updateButtonTapped(_ sender: Any) {
        
        UIView.animate(withDuration: 1) {
            self.entryFieldsFadeAway()
            self.backToNormal()
        }
        guard let entryText = reusableTextField.text, !entryText.isEmpty else { return }
        if milesTapped > 0 {
            milesButton.setTitle("\(entryText) miles", for: .normal)
            reusableTextField.text = ""
        } else if gallonsTapped > 0 {
            gallonsButton.setTitle("\(entryText) gallons", for: .normal)
            reusableTextField.text = ""
        } else if costTapped > 0 {
            costButton.setTitle("$\(entryText)", for: .normal)
            reusableTextField.text = ""
        }
        resetTappedTally()
    }
    
    
    @IBAction func saveFillUpButtonTapped(_ sender: Any) {
        
        
        
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
    
}
