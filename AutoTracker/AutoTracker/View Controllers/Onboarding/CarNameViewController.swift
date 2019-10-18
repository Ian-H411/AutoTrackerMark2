//
//  CarNameViewController.swift
//  AutoTracker
//
//  Created by Sam LoBue on 10/15/19.
//  Copyright © 2019 Ian Hall. All rights reserved.
//

import UIKit

class CarNameViewController: UIViewController {
    
    // MARK: - OUTLETS
    @IBOutlet weak var nameTextField: TextFieldStyle!
    @IBOutlet weak var takePictureButton: AutoTrackerButtonGreenBG!
    @IBOutlet weak var laterButton: AutoTrackerButtonWhiteBG!
    @IBOutlet weak var ownerNameTextField: UITextField!
    
    // MARK: - PROPERTIES
    var carParts: Car?
    
    // MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        ownerNameTextField.delegate = self
        
        
    }
    
    // MARK: - ACTIONS
    @IBAction func takePictureButtonTapped(_ sender: Any) {
        presentActionSheet()
    }
    
    @IBAction func finishIntroButtonTapped(_ sender: Any) {
        
        carParts?.name = nameTextField.text ?? "No Owner"
        guard let car = carParts else { return performSegue(withIdentifier: "toMainVC", sender: nil) }
        let name = car.name ?? "Default Name"
        let odometer = car.odometer
        let photoData = car.photoData
        car.odometer = odometer
        car.photoData = photoData
        let ownerName = ownerNameTextField.text ?? ""
        CarController.shared.carupdate(name: name, make: car.make ?? "", model: car.model ?? "", year: car.year ?? "", engine: car.engine ?? "" , ownerName: ownerName, car: car)
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
        performSegue(withIdentifier: "toMainVC", sender: nil)
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
    
    @IBAction func dismissKeyboardTapped(_ sender: Any) {
        nameTextField.resignFirstResponder()
        ownerNameTextField.resignFirstResponder()
    }
    
    // MARK: - HELPER FUNCTIONS
    
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
        let actionSheet = UIAlertController(title: "Car Picture", message: nil, preferredStyle: .alert)
        
        
        let cameraButton = UIAlertAction(title: "Use your Camera", style: .default) { (_) in
            self.camera()
        }
        actionSheet.addAction(cameraButton)
        
        
        let photoLibrary = UIAlertAction(title: "Import From Your Photo Library", style: .default) { (_) in
            self.photoLibrary()
        }
        
        actionSheet.addAction(photoLibrary)
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        actionSheet.addAction(cancelButton)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func presentInvalidFieldWarning(){
        let alertController = UIAlertController(title: "Invalid field", message: "it looks like your maintenance title may be empty go add something then try again", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(alertController, animated: true)
    }

    func noInfoAlert() {
        let alertController = UIAlertController(title: "We need at least one field to add a car to your garage", message: "Please provide information", preferredStyle: .alert)
        let accept = UIAlertAction(title: "Okay", style: .default)
        alertController.addAction(accept)
        present(alertController, animated: true)
}
}
extension CarNameViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        ownerNameTextField.resignFirstResponder()
        return true
    }
}

extension CarNameViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage{
            self.carParts?.photo = image
            takePictureButton.setTitle("Retake Picture", for: .normal)
            laterButton.setTitle("Finish Intro", for: .normal)
        } else {
            print("Something went wrong")
        }
        self.dismiss(animated: true, completion: nil)
    }
}
