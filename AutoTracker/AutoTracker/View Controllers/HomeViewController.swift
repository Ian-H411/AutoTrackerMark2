//
//  HomeViewController.swift
//  AutoTracker
//
//  Created by Sam LoBue on 10/7/19.
//  Copyright © 2019 Ian Hall. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - OUTLETS
    
    @IBOutlet weak var carImageView: UIImageView!
    @IBOutlet weak var carNameLabel: UILabel!
    @IBOutlet weak var averageMPGLabel: UILabel!
    @IBOutlet weak var lifetimeMilesLabel: UILabel!
    @IBOutlet weak var thisTankLabel: UILabel!
    @IBOutlet weak var scheduledMaintenanceTableView: UITableView!
    
    // MARK: - PROPERTIES
    var myCar: Car? {
        didSet {
            updateViews()
        }
    }
    
    var scheduledMaintenance: [Maintanence]{
        return CarController.shared.organizeAndReturnMaintainenceList()
    }
    
    var labels: [UILabel] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.myCar = CarController.shared.selectedCar
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scheduledMaintenanceTableView.delegate = self
        scheduledMaintenanceTableView.dataSource = self
    }
    
    // MARK: - ACTIONS
   
    @IBAction func updateProfilePictureButtonTapped(_ sender: Any) {
        presentActionSheet()
    }
    
    
    // MARK: - FUNCTIONS
    
    func updateViews() {
        guard let myCar = myCar else { return }

        carImageView.image = myCar.photo ?? UIImage(named: "car")
        carNameLabel.text = myCar.name ?? "Car Name"
        lifetimeMilesLabel.text = String(describing: myCar.odometer)
        lifetimeMilesLabel.layer.cornerRadius = 8
        averageMPGLabel.layer.cornerRadius = 8
        thisTankLabel.layer.cornerRadius = 8
        scheduledMaintenanceTableView.reloadData()
//        mostRecentMaintenanceLabel.isHidden = true
//        nextMostRecentMaintenanceLabel.isHidden = true
        
//        guard let scheduledMaintenance = scheduledMaintenance else { return }
//        mostRecentMaintenanceLabel.isHidden = false
//        mostRecentMaintenanceLabel.text = "No Maintenance Items For This Car"
//        if scheduledMaintenance.count <= 2 {
//            guard let maintenanceRequired = scheduledMaintenance.first?.maintanenceRequired, let dueOn = scheduledMaintenance.first?.dueOn else { return }
//            mostRecentMaintenanceLabel.isHidden = false
//            mostRecentMaintenanceLabel.text = maintenanceRequired + " | " + DateHelper.shared.stringForMaintenanceDate(date: dueOn)
//            if scheduledMaintenance.count > 1 {
//            guard let secondMaintenanceRequired = scheduledMaintenance[1].maintanenceRequired, let secondDueOn = scheduledMaintenance[1].dueOn else { return }
//            nextMostRecentMaintenanceLabel.isHidden = false
//            nextMostRecentMaintenanceLabel.text = secondMaintenanceRequired + " | " + DateHelper.shared.stringForMaintenanceDate(date: secondDueOn)
//            }
//        } else if scheduledMaintenance.count == 0 {
//
//        }
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

extension HomeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage{
            self.carImageView.image = image
            guard let car = myCar else { return }
            CarController.shared.updatePhoto(car: car, photo: image) { (success) in
                
            }
            
        } else {
            print("Something went wrong")
        }
        self.dismiss(animated: true, completion: nil)
    }
}
extension HomeViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        resignFirstResponder()
        return false
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
//        guard let scheduledMaintenance = scheduledMaintenance else { return 0 }
        return scheduledMaintenance.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "maintenanceCell", for: indexPath) as? MaintainenceDetailTableViewCell else {return UITableViewCell()}

        cell.scheduledMaintenance = scheduledMaintenance[indexPath.row]
        
        return cell
    }
    
    
}
