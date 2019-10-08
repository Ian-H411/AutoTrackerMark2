//
//  AddMaintenanceTableViewController.swift
//  AutoTracker
//
//  Created by Ian Hall on 10/7/19.
//  Copyright © 2019 Ian Hall. All rights reserved.
//

import UIKit

class AddMaintenanceTableViewController: UITableViewController {
    //MARK: -outlets
    
    @IBOutlet weak var maintenanceTextField: TextFieldStyle!
    
    @IBOutlet weak var addPhotoButton: UIButton!
    
    @IBOutlet weak var maintenanceReceiptPhoto: UIImageView!
    
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    
    @IBOutlet weak var additionalDetailsTextField: TextFieldStyle!
    
    var maintenance: Maintanence?
    
    var isInEditMode:Bool{
        if let _ = maintenance {
            return true
        } else {
            return false
        }
    }
    
    //MARK: - Variables
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    // MARK: - Helpers
    
    func initialSetup(){
        if isInEditMode{
            guard let maintenance = maintenance else {return}
            guard let date = maintenance.dueOn else {return}
            maintenanceTextField.text = maintenance.maintanenceRequired
            dueDatePicker.date = date
            additionalDetailsTextField.text = maintenance.details
            if let image = maintenance.photo{
                maintenanceReceiptPhoto.image = image
            }
        } else {
            addPhotoButton.setTitle("Tap to add a photo", for: .normal)
        }
    }
    
    //brings up a camera that we can use to take a pic
    
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
    
    func presentInvalidFieldWarning(){
        let alertController = UIAlertController(title: "Invalid field", message: "it looks like your maintenance title may be empty go add something then try again", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(alertController, animated: true)
    }
    
    
    
    //MARK: - ACTIONS
    
    @IBAction func addAPhotoButton(_ sender: Any) {
        presentActionSheet()
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        if isInEditMode{
            guard let maintenance = maintenance else {return}
            guard let title = maintenanceTextField.text, !title.isEmpty
                else {presentInvalidFieldWarning(); return}
            let image = maintenanceReceiptPhoto.image
            let details = additionalDetailsTextField.text
            let date = dueDatePicker.date
            CarController.shared.modifyMaintenanceRemainder(maintenance:maintenance , date: date, newTitle: title, details: details, image: image)
            self.navigationController?.popViewController(animated: true)
        } else {
            guard let title = maintenanceTextField.text, !title.isEmpty
                else {presentInvalidFieldWarning(); return}
            let image = maintenanceReceiptPhoto.image
            guard let car = CarController.shared.selectedCar else {return}
            let details = additionalDetailsTextField.text
            let date = dueDatePicker.date
            
            CarController.shared.addMaintenanceReminder(car: car, message: details, maintanence: title, date: date, image: image)
            self.navigationController?.popViewController(animated: true)
            
            
        }
    }
    
}

extension AddMaintenanceTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage{
            self.maintenanceReceiptPhoto.image = image
            self.addPhotoButton.setTitle("", for: .normal)
        } else {
            print("Something went wrong")
        }
        self.dismiss(animated: true, completion: nil)
    }
}
extension AddMaintenanceTableViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        resignFirstResponder()
        return false
    }
}
