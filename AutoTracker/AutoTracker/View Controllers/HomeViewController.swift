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
    @IBOutlet weak var thisTankLabel: UILabel!
    
    @IBOutlet weak var scheduledMaintenanceTableView: UITableView!
    
    @IBOutlet weak var updatePhotoButtton: UIButton!
    
    @IBOutlet weak var reviewIntroButton: UIButton!
    
    @IBOutlet weak var optionView: UIView!
    
    
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        if launchedBefore() {
//            self.performSegue(withIdentifier: "toOnboardingVC", sender: nil)
//        }
        scheduledMaintenanceTableView.delegate = self
        scheduledMaintenanceTableView.dataSource = self
        toggleOptions()
    }
    
    // MARK: - ACTIONS
    
    @IBAction func updateProfilePictureButtonTapped(_ sender: Any) {
        presentActionSheet()
    }
    @IBAction func displayOptions(_ sender: Any) {
        toggleOptions()
    }
    @IBAction func recordGasButtonTapped(_ sender: Any) {
        
////        if !(myCar?.odometer != nil) {
//        let window = UIWindow(frame: UIScreen.main.bounds)
//            let storyBoard = UIStoryboard(name: "Record", bundle: nil)
//            let entryVC = storyBoard.instantiateViewController(identifier: "receiptEntryVC")
//            window.rootViewController = entryVC
//
//            window.makeKeyAndVisible()
//
////        }
    }
    
    
    // MARK: - FUNCTIONS
    
    func updateViews() {
        guard let myCar = myCar else { return }
        
        carImageView.image = myCar.photo ?? UIImage(named: "car")
        self.navigationItem.title = myCar.name ?? "Car Name"
        updateOdometerLabel.text = String(describing: myCar.odometer)
        lifetimeMilesLabel.layer.cornerRadius = 8
        averageMPGLabel.layer.cornerRadius = 8
        thisTankLabel.layer.cornerRadius = 8
        scheduledMaintenanceTableView.reloadData()
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
    
    func toggleOptions(){
        hideMenu.toggle()
        optionView.isHidden = hideMenu
        updatePhotoButtton.isHidden = hideMenu
        reviewIntroButton.isHidden = hideMenu
        optionView.layer.shadowRadius = 10
        optionView.layer.shadowOffset = .zero
        optionView.layer.shadowColor = UIColor.black.cgColor
        optionView.layer.shadowOpacity = 0.5
        
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
    
    func launchedBefore() -> Bool {
    let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        return launchedBefore
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "maintenanceCell", for: indexPath) as? MaintenanceTableViewCell else {return UITableViewCell()}
        let main = scheduledMaintenance[indexPath.row]
        cell.delegate = self
        cell.update(maintenance: main)
        
        return cell
    }
    
    
}
extension HomeViewController: MaintenanceTableViewCellDelegate{
    func buttonTapped(_ sender: MaintenanceTableViewCell) {
        guard let main = sender.selectedMaintenance else {return}
        CarController.shared.toggleMaintenanceReminder(maintenance: main)
        scheduledMaintenanceTableView.reloadData()
    }
    
    
}
