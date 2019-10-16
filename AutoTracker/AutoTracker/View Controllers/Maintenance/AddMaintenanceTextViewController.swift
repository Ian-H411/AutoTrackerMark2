//
//  AddMaintenanceTextViewController.swift
//  AutoTracker
//
//  Created by Ian Hall on 10/15/19.
//  Copyright © 2019 Ian Hall. All rights reserved.
//

import UIKit
import UserNotifications

class AddMaintenanceTextViewController: UIViewController {
    //MARK: - OUTLETS
    
    @IBOutlet weak var answerTextField: UITextField!
    
    
    @IBOutlet weak var maintenanceTypeButton: AutoTrackerButtonGreenBG!
    
    
    @IBOutlet weak var costAndReceipt: AutoTrackerButtonGreenBG!
    
    @IBOutlet weak var dueDateLabel: UILabel!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var SaveButton: AutoTrackerButtonGreenBG!
    
    @IBOutlet weak var additionalDetailsLabel: AutoTrackerGreenLabel!
    
    @IBOutlet weak var additionalDetailsTextField: AutoTrackerTextField!
    
    //MARK: - Variables
    
    
    var titleString:String?
    
    var details:String?
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    var maintenanceToSend:Maintanence?
    
    //MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        toggleAuxillaryLabels()
        additionalDetailsTextField.delegate = self
        
        
    }
    
    
    //MARK: - ACTIONS
    
    @IBAction func maintenanceTypeButtonTapped(_ sender: Any) {
        toggleAuxillaryLabels()
        toggleMaintenanceLabels()
        
    }
    
    
    @IBAction func costAndReceiptButtonTapped(_ sender: Any) {
        guard let title = titleString else {return}
        guard let details = details else {return}
        let date = datePicker.date
        guard let car = CarController.shared.selectedCar else {return}
        let main = CarController.shared.addMaintenanceReminder(car: car, message: details , maintanence: title, date: date, image: nil, price: "")
        maintenanceToSend = main
        if date > Date(){
            addReminderPrompt()
        } else {
            self.performSegue(withIdentifier: "nextStep", sender: nil)
        }
        
    }
    
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        if additionalDetailsLabel.isHidden{
            guard let titleText = answerTextField.text else {return}
            title = titleText
            maintenanceTypeButton.setTitle(titleText, for: .normal)
            toggleMaintenanceLabels()
            answerTextField.resignFirstResponder()
            answerTextField.isHidden = true
        } else {
            additionalDetailsTextField.resignFirstResponder()
        }
        SaveButton.isHidden = true
    }
    
    
    //MARK: -HELPER FUNCTIONS
    
    func toggleAuxillaryLabels(){
        
        self.answerTextField.isHidden.toggle()
        self.SaveButton.isHidden.toggle()
        
        
    }
    func addReminderPrompt(){
        let alertController = UIAlertController(title: "add a reminder?", message: "This is set to a future date would you like to add a notification?", preferredStyle: .alert)
        let okayButton = UIAlertAction(title: "Add Notification", style: .default) { (_) in
            self.notificationSetUP()
            
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        let okayButNoNotification = UIAlertAction(title: "Just add the mainteinance", style: .default) { (_) in
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "nextStep", sender: nil)
            }
        }
        alertController.addAction(okayButton)
        alertController.addAction(okayButNoNotification)
        alertController.addAction(cancelButton)
        self.present(alertController,animated: true)
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
            let date = self.datePicker.date
            guard let bodyText = self.answerTextField.text else {return}
            
            guard let main = self.maintenanceToSend else {return}
            let id = main.uuid ?? ""
            let content = UNMutableNotificationContent()
            content.title = "You have some car maintenance"
            content.body = "\(bodyText) is due!"
            content.sound = .default
            let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: date)
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
            let identifier = id
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            
            self.notificationCenter.add(request) { (error) in
                if let error = error {
                    print("Error \(error.localizedDescription)")
                }
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "nextStep", sender: nil)
                }
                
            }
        }
    }
    
    
    
    func toggleMaintenanceLabels(){
        
        self.maintenanceTypeButton.isHidden.toggle()
        self.dueDateLabel.isHidden.toggle()
        self.datePicker.isHidden.toggle()
        self.additionalDetailsLabel.isHidden.toggle()
        self.additionalDetailsTextField.isHidden.toggle()
        self.costAndReceipt.isHidden.toggle()
        
        
    }
    
    func toggleTextFieldLabels(){
        self.maintenanceTypeButton.isHidden.toggle()
        self.dueDateLabel.isHidden.toggle()
        self.datePicker.isHidden.toggle()
        self.costAndReceipt.isHidden.toggle()
        
        
    }
    
    //MARK: - NAVIGATION
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "nextStep"{
            if let destination = segue.destination as? AddMaintenancePicAndPriceViewController{
                destination.incomingMaintenance = maintenanceToSend
            }
        }
    }
    
    
    
    //MARK: - EXTENSIONS
    
    
}
extension AddMaintenanceTextViewController: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        toggleTextFieldLabels()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let detailsString = additionalDetailsTextField.text, !detailsString.isEmpty else {return false}
        details = detailsString
        toggleTextFieldLabels()
        SaveButton.isHidden = true
        textField.resignFirstResponder()
        return true
        
    }
    
}
