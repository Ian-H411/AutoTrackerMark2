//
//  AddReceiptTableViewController.swift
//  AutoTracker
//
//  Created by Sam LoBue on 10/8/19.
//  Copyright © 2019 Ian Hall. All rights reserved.
//

import UIKit

class AddReceiptTableViewController: UITableViewController {
    
    // MARK: - OUTLETS
    @IBOutlet weak var receiptTextField: UITextField!
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var receiptPhoto: UIImageView!
    @IBOutlet weak var transactionDatePicker: UIDatePicker!
    @IBOutlet weak var totalTextField: UITextField!
    @IBOutlet weak var ppgTextField: UITextField!
    
    // MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        addPhotoButton.setTitle("Tap to add a photo", for: .normal)
    }
    
    // MARK: - ACTIONS
    @IBAction func receiptPhotoButtonTapped(_ sender: Any) {
        presentActionSheet()
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let name = receiptTextField.text, !name.isEmpty,
            let image = receiptPhoto.image,
            let total = totalTextField.text, !total.isEmpty,
            let ppg = ppgTextField.text, !ppg.isEmpty
            else { return }
        let transactionDate = transactionDatePicker.date
        ReceiptController.shared.addReceiptWith(name: name, timestamp: transactionDate, photo: image, total: total, ppg: ppg)
        self.navigationController?.popViewController(animated: true)
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
    
    func presentInvalidFieldWarning(){
        let alertController = UIAlertController(title: "Invalid field", message: "it looks like your maintenance title may be empty go add something then try again", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(alertController, animated: true)
    }
}

extension AddReceiptTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage{
            self.receiptPhoto.image = image
            self.addPhotoButton.setTitle("", for: .normal)
        } else {
            print("Something went wrong")
        }
        self.dismiss(animated: true, completion: nil)
    }
}

extension AddReceiptTableViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        resignFirstResponder()
        return false
    }
}
