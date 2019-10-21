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

    @IBOutlet weak var averageMPGLabel: UILabel!
    @IBOutlet weak var lifetimeMilesLabel: UILabel!
    @IBOutlet weak var updateOdometerLabel: AutoTrackerGreenLabel!
    @IBOutlet weak var scheduledMaintenanceTableView: UITableView!
    @IBOutlet weak var updatePhotoButtton: UIButton!
    @IBOutlet weak var reviewIntroButton: UIButton!
    @IBOutlet weak var optionView: UIView!

    @IBOutlet weak var infoButton: UIButton!
    
    // MARK: - PROPERTIES
    var myCar: Car? {
        didSet {
            updateViews()
        }
    }
    
    var hideMenu = false
    
    var scheduledMaintenance: [Maintanence]{
        let list = CarController.shared.organizeAndReturnMaintainenceList()
        var returnList: [Maintanence] = []
        for item in list {
            if !item.isComplete && !item.isReceipt{
                returnList.append(item)
            }
        }
        return returnList
    }
    
    var labels: [UILabel] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        self.myCar = CarController.shared.selectedCar
        optionView.layer.shadowRadius = 10
        optionView.layer.shadowOffset = .zero
        optionView.layer.shadowColor = UIColor.black.cgColor
        optionView.layer.shadowOpacity = 0.5
        optionView.layer.masksToBounds = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scheduledMaintenanceTableView.delegate = self
        scheduledMaintenanceTableView.dataSource = self
        toggleOptions()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        view.removeBlur()
        optionView.isHidden = true
    }
    
    // MARK: - ACTIONS
    
    @IBAction func updateProfilePictureButtonTapped(_ sender: Any) {
        presentActionSheet()
    }
    @IBAction func displayOptions(_ sender: Any) {
        toggleOptions()
    }
    @IBAction func recordGasButtonTapped(_ sender: Any) {
        tabBarController?.selectedIndex = 1
    }
    
    
    // MARK: - FUNCTIONS
    
    func averageMPG() -> Int {
        let receipts = CarController.shared.organizeAndReturnReceipts()
        var mpgArray: [Double] = []
        for mpg in receipts {
            mpgArray.append(mpg.odometerStamp)
        }
        
        let averageMPG = mpgArray.reduce(0, +)
        return (Int(averageMPG) / mpgArray.count)
    }
    
    ///called when the user needs to update the views and labels
    func updateViews() {
        guard let myCar = myCar else { return }

        carImageView.image = myCar.photo ?? UIImage(named: "car")
        self.navigationItem.title = myCar.name ?? "Car Name"
        updateOdometerLabel.text = String(describing: myCar.odometer)
        lifetimeMilesLabel.text = String(averageMPG())
        lifetimeMilesLabel.layer.cornerRadius = 8
        averageMPGLabel.layer.cornerRadius = 8

        scheduledMaintenanceTableView.reloadData()
    }
    
    ///used for when the camera is called upon to add a photo
    func camera() {

        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = .camera
            self.present(myPickerController, animated: true , completion: nil)
        }
    }
    

    ///used when the user wishes to use a photo from their library

    func photoLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let mypickerController = UIImagePickerController()
            mypickerController.delegate = self
            mypickerController.sourceType = .photoLibrary
            self.present(mypickerController, animated: true, completion: nil)
        }
    }
    

    ///turns the menu on and off
    func toggleOptions() {

        if hideMenu{
            view.blurView(style: .extraLight)
            view.bringSubviewToFront(optionView)
        }else {
            UIView.animate(withDuration: 0.5) {
                self.view.removeBlur()
            }

        }
        hideMenu.toggle()
        let alpha = hideMenu ? CGFloat(0.0) : CGFloat(1.0)
        UIView.animate(withDuration: 0.5) {
            self.infoButton.isHidden = self.hideMenu
            self.infoButton.alpha = alpha
            self.optionView.isHidden = self.hideMenu
            self.optionView.alpha = alpha
            self.updatePhotoButtton.alpha = alpha
            self.reviewIntroButton.alpha = alpha
            self.updatePhotoButtton.isHidden = self.hideMenu
            self.reviewIntroButton.isHidden = self.hideMenu
        }
    }
    

    ///presents the action sheet allowing the user to use their photo and photo library
    func presentActionSheet() {

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
    

    ///presented when the user has an empty field or is invalid
    func presentInvalidFieldWarning() {

        let alertController = UIAlertController(title: "Invalid field", message: "it looks like your maintenance title may be empty go add something then try again", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(alertController, animated: true)
    }
    

    //checks if the user has used the app before

    func launchedBefore() -> Bool {
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        return launchedBefore
    }
}


//MARK: - EXTENSIONS

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

extension HomeViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        resignFirstResponder()
        return false
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scheduledMaintenance.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "maintenanceCell", for: indexPath) as? MaintenanceTableViewCell else {return UITableViewCell()}

        
        if self.scheduledMaintenance.count == 0 {
            let dummyText = "No Maintenance Items"
            cell.updateDummyText(dummyText: dummyText)
            return cell
        } else {
        
        let main = scheduledMaintenance[indexPath.row]
        cell.delegate = self
        cell.update(maintenance: main)
        
        return cell
        }
    }
    
}

extension HomeViewController: MaintenanceTableViewCellDelegate{

    func buttonTapped(_ sender: MaintenanceTableViewCell) {
        guard let main = sender.selectedMaintenance else {return}
        CarController.shared.toggleMaintenanceReminder(maintenance: main)
        scheduledMaintenanceTableView.reloadData()
    }

}
