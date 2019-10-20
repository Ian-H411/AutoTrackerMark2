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
    
    @IBOutlet weak var odometerPicker: UIPickerView!
    
    @IBOutlet weak var photoButton: AutoTrackerButtonWhiteBG!
    
    @IBOutlet weak var carImage: UIImageView!
    
    
    // MARK: - PROPERTIES
    var odometer = ["0","1","2","3","4","5","6","7","8","9"]
    
    var carToEdit: Car?
    
    var isInEditMode: Bool = false
    
    
    // MARK: - LIFECYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        yearTextField.delegate = self
        odometerPicker.delegate = self
        odometerPicker.dataSource = self
        engineTextField.delegate = self
        modelTextField.delegate = self
        nameTextField.delegate = self
        ownerTextField.delegate = self
        initialSetUp()
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
            !engine.isEmpty
            else { return }
        if year.count != 4 {
            notAValidYear()
            yearTextField.text = ""
            return
        }
        let odometer = odometerResults()
        if isInEditMode{
            guard let car = carToEdit else {return}
            CarController.shared.carupdate(name: name, make: make, model: model, year: year, engine: engine, ownerName: owner, car: car)
            if let image = carImage.image {
                CarController.shared.updatePhoto(car: car, photo: image) { (_) in
                }
            }
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
            return
        }
        let car = CarController.shared.addACar(name: name, make: make, model: model, year: year, engine: engine, ownerName: owner, odometer: Double(odometer))
        CarController.shared.selectedCar = car
        if let image = carImage.image {
            CarController.shared.updatePhoto(car: car, photo: image) { (_) in
            }
        }
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    @IBAction func photoButtonTapped(_ sender: Any) {
        presentActionSheet()
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
    
    func initialSetUp() {
        addDoneButtonOnKeyboard(textField: yearTextField)
        if let car = carToEdit {
            nameTextField.text = car.name
            ownerTextField.text = car.ownerName
            makeTextField.text = car.make
            modelTextField.text = car.model
            engineTextField.text = car.engine
            
            isInEditMode = true
            yearTextField.text = car.year
            setPickerViewToCarValue()
            if let photo = car.photo{
                carImage.image = photo
                photoButton.setTitle("", for: .normal)
            } else {
                photoButton.setTitle("Tap to add a photo", for: .normal)
            }
        } else {
            photoButton.setTitle("Tap to add a photo", for: .normal)
        }
        
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
        if let text = yearTextField.text, !text.isNumeric {
                self.notANumberAlert()
            }
    }
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
    
    func presentActionSheet(){
        let actionSheet = UIAlertController(title: "Import Receipt Photo", message: nil, preferredStyle: .actionSheet)
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
    
    
    
}

extension AddCarTableViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
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
extension AddCarTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage{
            carImage.image = image
            photoButton.setTitle("", for: .normal)
            tableView.reloadData()
        } else {
            print("Something went wrong")
        }
        self.dismiss(animated: true, completion: nil)
    }
}
