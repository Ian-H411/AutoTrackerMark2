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
    
    
    var imageOfReveipt: UIImage?
    
    
    
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
        addDoneButtonOnKeyboard(textField: reusableTextField)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        reusableTextField.resignFirstResponder()
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
        
        reusableTextField.resignFirstResponder()
        UIView.animate(withDuration: 1) {
            self.entryFieldsFadeAway()
            self.backToNormal()
        }
        resetTappedTally()
    }
    
    @IBAction func cameraButtonTapped(_ sender: Any) {
        presentActionSheet()
    }
    
    
    
    @IBAction func saveFillUpButtonTapped(_ sender: Any) {
        reusableTextField.resignFirstResponder()
        guard let car = CarController.shared.selectedCar,
            
            let gallons = gallonsButton.titleLabel?.text,
            let cost = costButton.titleLabel?.text else { return }
        
        if gallons == "Gallons" || cost == "Cost" || miles == 0 {
            
            emptyFieldsAlert()
            
        } else {
            
            CarController.shared.addReceipt(car: car, miles: miles, gallons: gallons, cost: cost, image: imageOfReveipt)
            
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
    func addDoneButtonOnKeyboard(textField: UITextField){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(self.doneButtonAction))
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        textField.inputAccessoryView = doneToolbar
    }
    @objc func doneButtonAction(){
        reusableTextField.resignFirstResponder()
        
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
    
    ///Animation to bring a textfield and button on screen
    
    func presentActionSheet(){
        let actionSheet = UIAlertController(title: "Import Receipt Photo", message: nil, preferredStyle: .alert)
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let cameraButton = UIAlertAction(title: "Import With Camera", style: .default) { (_) in
                self.camera()
            }
            actionSheet.addAction(cameraButton)
        }
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let photoLibrary = UIAlertAction(title: "Import From Photo Library", style: .default) { (_) in
                self.photoLibrary()
            }
            actionSheet.addAction(photoLibrary)
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        actionSheet.addAction(cancelButton)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func camera(){
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = .camera
            self.present(myPickerController, animated: true , completion: nil)
        }
    }
    
    func photoLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let mypickerController = UIImagePickerController()
            mypickerController.delegate = self
            mypickerController.sourceType = .photoLibrary
            self.present(mypickerController, animated: true, completion: nil)
        }
    }
    
    
    func entryFieldsAppear() {
        updateButton.alpha = 1.0
        reusableTextField.alpha = 1.0
    }
    
    ///Animation to fade the textfield and button off screen
    func entryFieldsFadeAway() {
        updateButton.alpha = 0.0
        reusableTextField.alpha = 0.0
    }
    
    ///Animation that brings the screen back to its orginal state
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
    
    ///Keeps a tally on which buttons are tapped for animating them
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

extension ReceiptEntryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage{
            imageOfReveipt = image
            
        } else {
            print("Something went wrong")
        }
        self.dismiss(animated: true, completion: nil)
    }
}
