//
//  AddMaintenanceTableViewController.swift
//  AutoTracker
//
//  Created by Ian Hall on 10/7/19.
//  Copyright © 2019 Ian Hall. All rights reserved.
//

import UIKit
import UserNotifications

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
    
    let notificationCenter = UNUserNotificationCenter.current()
    
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
    
    func notificationSetUP(){
        let options:UNAuthorizationOptions = [.alert,.sound]
        notificationCenter.requestAuthorization(options: options) { (didAllow, error) in
            if let error = error{
                print("there was an error in \(#function) :\(error) : \(error.localizedDescription)")
                return
            }
            if didAllow{
                self.createNotification()
            }
        }
    }
    
    func createNotification(){
        DispatchQueue.main.async {
            let date = self.dueDatePicker.date
            guard let bodyText = self.maintenanceTextField.text else {return}
            
            
            let content = UNMutableNotificationContent()
            content.title = "You have some car maintenance"
            content.body = "\(bodyText) is due!"
            content.sound = .default
            let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: date)
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
            let identifier = "Notification"
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            
            self.notificationCenter.add(request) { (error) in
                if let error = error {
                    print("Error \(error.localizedDescription)")
                }
                self.useSave()
            }
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
    func addReminderPrompt(){
        let alertController = UIAlertController(title: "add a reminder?", message: "This is set to a future date would you like to add a notification?", preferredStyle: .alert)
        let okayButton = UIAlertAction(title: "Add Notification", style: .default) { (_) in
            self.createNotification()
            
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        let okayButNoNotification = UIAlertAction(title: "Just add the mainteinance with no notificiation", style: .default) { (_) in
            self.useSave()
        }
        alertController.addAction(okayButton)
        alertController.addAction(okayButNoNotification)
        alertController.addAction(cancelButton)
        self.present(alertController,animated: true)
    }
    func useSave(){
        DispatchQueue.main.async {
            if self.isInEditMode{
                guard let maintenance = self.maintenance else {return}
                guard let title = self.maintenanceTextField.text, !title.isEmpty
                    else {self.presentInvalidFieldWarning(); return}
                let image = self.maintenanceReceiptPhoto.image
                let details = self.additionalDetailsTextField.text
                let date = self.dueDatePicker.date
            CarController.shared.modifyMaintenanceRemainder(maintenance:maintenance , date: date, newTitle: title, details: details, image: image)
            self.navigationController?.popViewController(animated: true)
        } else {
                guard let title = self.maintenanceTextField.text, !title.isEmpty
                    else {self.presentInvalidFieldWarning(); return}
                let image = self.maintenanceReceiptPhoto.image
            guard let car = CarController.shared.selectedCar else {return}
                let details = self.additionalDetailsTextField.text
                let date = self.dueDatePicker.date
            
            CarController.shared.addMaintenanceReminder(car: car, message: details, maintanence: title, date: date, image: image, price: "")
            self.navigationController?.popViewController(animated: true)
            }
            
        }
    }
    
    //MARK: - ACTIONS
    
    @IBAction func addAPhotoButton(_ sender: Any) {
        presentActionSheet()
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        if dueDatePicker.date > Date(){
            notificationSetUP()
            return
        }
        useSave()
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
