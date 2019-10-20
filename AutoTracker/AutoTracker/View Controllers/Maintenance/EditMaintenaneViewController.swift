//
//  EditMaintenaneViewController.swift
//  AutoTracker
//
//  Created by Ian Hall on 10/16/19.
//  Copyright © 2019 Ian Hall. All rights reserved.
//

import UIKit

class EditMaintenaneViewController: UIViewController {
//MARK: - OUTLETS
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var titleTextField: AutoTrackerTextField!
    
    @IBOutlet weak var priceTextField: AutoTrackerTextField!
    
    @IBOutlet weak var detailsTextField: AutoTrackerTextField!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    //MARK: - VARIABLES
    
    var selectedMaintenance: Maintanence?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialUISetUp()
        imageView.layer.cornerRadius = 20
        imageView.layer.borderColor = UIColor.autoGreen.cgColor
        imageView.layer.borderWidth = 3
    }
    
    //MARK: - HELPERS
    func initialUISetUp(){
        guard let main = selectedMaintenance else {return}
        imageView.image = main.photo ?? UIImage(named: "car")!
        titleTextField.text = main.maintanenceRequired
        detailsTextField.text = main.details
        priceTextField.text = main.price
        datePicker.date = main.dueOn ?? Date()
        titleTextField.delegate = self
        detailsTextField.delegate = self
        priceTextField.delegate = self
        
    }
    
    func presentActionSheet() {
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
    
    func camera() {
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
    
    //MARK: - ACTIONS
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let title = titleTextField.text,
            let detials = detailsTextField.text,
            let price = priceTextField.text,
            let image = imageView.image,
            let main = selectedMaintenance
            else {return}
        CarController.shared.modifyMaintenance(maintenance: main, date: datePicker.date, newTitle: title, details: detials, image: image)
        CarController.shared.modifyMaintenance(price: price, maintenance: main)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func editPhotoButtonTapped(_ sender: Any) {
        presentActionSheet()
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editphoto"{
            if let destination = segue.destination as? ImageDisplayViewController{
                destination.imageToDisplay = imageView.image
            }
        }
    }
}
//MARK: - EXTENSIONS
extension EditMaintenaneViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension EditMaintenaneViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
             self.dismiss(animated: true, completion: nil)
     }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage{
            imageView.image = image
        } else {
            print("Something went wrong")
        }
        self.dismiss(animated: true, completion: nil)
    }
}
