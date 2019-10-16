//
//  AddMaintenancePicAndPriceViewController.swift
//  AutoTracker
//
//  Created by Ian Hall on 10/15/19.
//  Copyright © 2019 Ian Hall. All rights reserved.
//

import UIKit

class AddMaintenancePicAndPriceViewController: UIViewController {

    //MARK: - OUTLETS
    
    @IBOutlet weak var answertextField: AutoTrackerTextField!
    
    @IBOutlet weak var takePictureOfReceiptButton: AutoTrackerButtonGreenBG!
    
    @IBOutlet weak var enterCostButton: AutoTrackerButtonGreenBG!
    
    @IBOutlet weak var updateOdometerButton: AutoTrackerButtonGreenBG!

    @IBOutlet weak var goBackButton: AutoTrackerButtonGreenBG!
    
    @IBOutlet weak var receiptImage: UIImageView!
    
    //MARK: - VARIABLES
    
    
    var incomingMaintenance: Maintanence?
    
    
    
    //MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        answertextField.delegate = self
        self.navigationItem.hidesBackButton = true
        receiptImage.isHidden = true
        answertextField.isHidden = true
    }
    
    
    
    //MARK: - ACTIONS
    
    @IBAction func takePictureButtonTapped(_ sender: Any) {
        presentActionSheet()
    }
    
    
    @IBAction func enterCostButtonTapped(_ sender: Any) {
        takePictureOfReceiptButton.isHidden = true
        enterCostButton.isHidden = true
        answertextField.isHidden = false
        updateOdometerButton.isHidden = true
        goBackButton.isHidden = true
    }
    
    @IBAction func updateCarsOdometerButtonTapped(_ sender: Any) {
        
    }
    @IBAction func imageButtonTapped(_ sender: Any) {
        if let _ = receiptImage.image {
            self.performSegue(withIdentifier: "enlarge", sender: nil)
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    //MARK: - HELPERS
    
    
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
    
    
    
    


    // MARK: - Navigation


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newMainOdo"{
            if let destination = segue.destination as? UpdateOdometerViewController{
                guard let main = incomingMaintenance else {return}
                destination.maintenance = main
            }
        } else if segue.identifier == "enlarge"{
            if let destination = segue.destination as? ImageDisplayViewController {
                guard let image = receiptImage.image else {return}
                destination.imageToDisplay = image
            }
        }
    }


}
extension AddMaintenancePicAndPriceViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        takePictureOfReceiptButton.isHidden = false
        guard let main = incomingMaintenance else {return true}
             enterCostButton.isHidden = false
             answertextField.isHidden = true
             updateOdometerButton.isHidden = false
             goBackButton.isHidden = false
        guard let price = textField.text else {return true}
        enterCostButton.setTitle(price, for: .normal)
        CarController.shared.modifyMaintenance(price: price, maintenance: main)
        return true
    }
}
extension AddMaintenancePicAndPriceViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            self.dismiss(animated: true, completion: nil)
    }
   func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
       if let image = info[.originalImage] as? UIImage{
           self.receiptImage.image = image
        guard let main = incomingMaintenance else {return}
        CarController.shared.modifyMaintenance(photo: image, maintenance: main)
        self.receiptImage.isHidden = false
       } else {
           print("Something went wrong")
       }
       self.dismiss(animated: true, completion: nil)
   }
}
