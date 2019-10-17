//
//  AddCarByVinViewController.swift
//  AutoTracker
//
//  Created by Ian Hall on 10/9/19.
//  Copyright © 2019 Ian Hall. All rights reserved.
//

import UIKit

class AddCarByVinViewController: UIViewController {
    
    //MARK: - OUTLETS
    
    @IBOutlet weak var headerLabel: AutoTrackerLabelDetail!
    
    @IBOutlet weak var vinLabel: UILabel!
    
    @IBOutlet weak var vinTextField: AutoTrackerTextField!
    
    @IBOutlet weak var yearLabel: UILabel!
    
    @IBOutlet weak var yearTextField: AutoTrackerTextField!
    
    @IBOutlet weak var makeLabel: UILabel!
    
    @IBOutlet weak var makeTextField: AutoTrackerTextField!
    
    @IBOutlet weak var modelLabel: UILabel!
    
    @IBOutlet weak var modelTextField: AutoTrackerTextField!
    
    @IBOutlet weak var engineLabel: UILabel!
    
    @IBOutlet weak var engineTextField: AutoTrackerTextField!
    
    @IBOutlet weak var goButton: AutoTrackerButtonAsLabel!
    
    //MARK: - VAIABLES
    
    var car: CarJson?
    var vinStore: String?
    
    
    //MARK: -LIFECYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        vinTextField.delegate = self
        yearTextField.delegate = self
        makeTextField.delegate = self
        modelTextField.delegate = self
        engineTextField.delegate = self
        addDoneButtonOnKeyboard(textField: yearTextField)
    }
    
    
    //MARK: - HELPERS
    
    func setUpUI(){
        goButton.isHidden = true
        self.yearLabel.alpha = 0.0
        self.makeLabel.alpha = 0.0
        self.makeTextField.alpha = 0.0
        self.modelLabel.alpha = 0.0
        self.modelTextField.alpha = 0.0
        self.engineLabel.alpha = 0.0
        self.engineTextField.alpha = 0.0
        self.goButton.alpha = 0.0
        self.yearTextField.alpha = 0.0
        let labelCarousel:[UILabel] = [yearLabel, makeLabel,modelLabel,engineLabel]
        for label in labelCarousel{
            label.isHidden = true
        }
        let textFieldCarousel:[UITextField] = [yearTextField,makeTextField,modelTextField,engineTextField]
        for field in textFieldCarousel{
            field.isHidden = true
        }
    }
    
    func dataRecievedBeginSetup(carJson:CarJson){
        UIView.animate(withDuration: 2) {
            self.makeLabel.isHidden = false
            self.makeTextField.isHidden = false
            self.modelLabel.isHidden = false
            self.modelTextField.isHidden = false
            self.engineLabel.isHidden = false
            self.engineTextField.isHidden = false
            self.goButton.isHidden = false
            self.yearTextField.isHidden = false
            self.yearLabel.isHidden = false
            self.yearLabel.alpha = 1.0
            self.makeLabel.alpha = 1.0
            self.makeTextField.alpha = 1.0
            self.modelLabel.alpha = 1.0
            self.modelTextField.alpha = 1.0
            self.engineLabel.alpha = 1.0
            self.engineTextField.alpha = 1.0
            self.goButton.alpha = 1.0
            self.yearTextField.alpha = 1.0
            self.yearTextField.text = carJson.year == "" ? "Year not Found" : carJson.year
            self.makeTextField.text = carJson.make == "" ? "Car Make not found" : carJson.make
            self.modelTextField.text = carJson.model == "" ? "Car model not found" : carJson.model
            self.engineTextField.text = carJson.engine == "" ? "Engine not found" : "\(carJson.engine) Cylinder"
            
        }
    }
    
    func beginDataFetchByCarVin(){
        guard let vin = vinTextField.text?.uppercased(), !vin.isEmpty
            else {return}
        if !Reachability.isConnectedToNetwork(){
            presentNoInternetAlert()
            return
        }
        vinStore = vin
        CarController.shared.retrieveCarDetailsWith(vin: vin, year: "") { (carJson, error) in
            if let error = error{
                print("there was an error in \(#function) :\(error) : \(error.localizedDescription)")
                return
            }
            guard let car = carJson else {return}
            DispatchQueue.main.async {
                self.dataRecievedBeginSetup(carJson:car)
                self.headerLabel.isHidden = true
            }
            
        }
        
    }
    func displayYearTextField(){
        yearTextField.isHidden = false
        yearLabel.isHidden = false
        headerLabel.text = "Whats the cars model year?"
    }
    
    func presentAreYouSureAlert(){
        let alert = UIAlertController(title: "Everything look alright??", message: "", preferredStyle: .alert)
        let yesbutton = UIAlertAction(title: "Yes, it looks great", style: .default) { (_) in
            guard let make = self.makeTextField.text, !make.isEmpty,
                let model = self.modelTextField.text, !model.isEmpty,
                let year = self.yearTextField.text, !year.isEmpty,
                let engine = self.engineTextField.text, !engine.isEmpty
                else {return}
            let car = CarJson(make: make, model: model, year: year, engine: engine)
            self.car = car
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "finalCheck", sender: nil)
            }
        }
        let cancelButton = UIAlertAction(title: "Not Quite", style: .destructive, handler: nil)
        alert.addAction(yesbutton)
        alert.addAction(cancelButton)
        self.present(alert, animated: true)
    }
    
    func presentNoInternetAlert(){
        let alert = UIAlertController(title: "No Internet", message: "Sorry but this function requires an internet connection.  check your connection and try again", preferredStyle: .alert)
        let okayButton = UIAlertAction(title: "okay", style: .default, handler: nil)
        alert.addAction(okayButton)
        self.present(alert, animated: true)
    }
    
    func addDoneButtonOnKeyboard(textField: UITextField){
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
    
    //MARK: - ACTIONS
    
    @IBAction func looksGoodButtonTapped(_ sender: Any) {
        presentAreYouSureAlert()
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "finalCheck"{
            if let destinationVC = segue.destination as? FinalCheckForVinViewController{
                destinationVC.car = car
                destinationVC.vin = vinStore
            }
        }
    }
    
    
    //MARK: - EXTENSIONS
    
}
extension AddCarByVinViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField.tag == 1{
            beginDataFetchByCarVin()
        }
        
        return true
    }

}
