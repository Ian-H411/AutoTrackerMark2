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
    
    // MARK: - PROPERTIES
    var carParts: Car?
    
    // MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
    }
    
    // MARK: - ACTIONS
    @IBAction func takePictureButtonTapped(_ sender: Any) {
        presentActionSheet()
    }
    
    @IBAction func finishIntroButtonTapped(_ sender: Any) {
        guard let car = carParts else { return }
        let name = car.name ?? "Default Name"
        let vin = car.vin ?? "Missing VIN"
        let odometer = car.odometer
        let photoData = car.photoData
        CarController.shared.onboardACar(name: name, vin: vin, odometer: odometer, photoData: photoData)
        performSegue(withIdentifier: "toMainVC", sender: nil)
        
        
        
        
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CarNameViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        carParts?.name = nameTextField.text
        nameTextField.resignFirstResponder()
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
