//
//  MyGarageViewController.swift
//  AutoTracker
//
//  Created by Ian Hall on 10/6/19.
//  Copyright © 2019 Ian Hall. All rights reserved.
//

import UIKit

class MyGarageViewController: UIViewController {
    
    //MARK: - OUTLETS
    
    
    @IBOutlet weak var currentCarButton: AutoTrackerButtonGreenBG!
    
    @IBOutlet weak var odometerPicker: UIPickerView!
    
    @IBOutlet weak var makeLabel: AutoTrackerLabel!
    
    @IBOutlet weak var ownerLabel: AutoTrackerLabel!
    
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var carSelectionTableView: UITableView!
    
    @IBOutlet weak var savebutton: AutoTrackerButtonGreenBG!
    
    
    @IBOutlet weak var editCurrentCarButton: AutoTrackerButtonWhiteBG!
    
    @IBOutlet weak var addCarByTextButton: AutoTrackerButtonWhiteBG!
    
    @IBOutlet weak var addCarByVinButton: AutoTrackerButtonWhiteBG!
    
    @IBOutlet weak var menuCard: UIView!
    
    
    //MARK: - Needed Variables
    
    var isInCarSelectionMode:Bool = false
    
    var odometer = ["0","1","2","3","4","5","6","7","8","9"]
    
    var currentCarSelected: Car?
    
    var hackCarDeleteButton:Car?
    
    // programatically creates a cgrect that we can set the tableView height to
    var tableViewSize:CGRect{
        if isInCarSelectionMode{
            let x = stackView.frame.origin.x
            let y = stackView.frame.origin.y
            let width = stackView.frame.width
            var contentSize = 81
            if let garage = CarController.shared.garage {
                contentSize = 81 * garage.count 
            }
            let height = CGFloat( contentSize )
            if height < stackView.frame.height{
                return CGRect(x: x, y: y, width: width, height: stackView.frame.height)
            }
            return CGRect(x: x, y: y, width: width, height: height)
        } else {
            let x = stackView.frame.origin.x
            let y = stackView.frame.origin.y
            let width = stackView.frame.width
            let height = CGFloat(81)
            return CGRect(x: x, y: y, width: width, height:height)
        }
    }
    
    //MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetUP()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        viewWillAppearSetUP()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        view.removeBlur()
    }
    //MARK: - HELPER FUNCTIONS
    
    func viewWillAppearSetUP(){
        carSelectionTableView.reloadData()
           setPickerViewToCarValue()
           menuCard.isHidden = true
           menuCard.alpha = 0.0
           addCarByVinButton.alpha = 0.0
           addCarByVinButton.isHidden = true
           addCarByTextButton.alpha = 0.0
           addCarByTextButton.isHidden = true
           editCurrentCarButton.isHidden = true
           editCurrentCarButton.alpha = 0.0
           menuCard.layer.shadowRadius = 10
           menuCard.layer.shadowOffset = .zero
           menuCard.layer.shadowColor = UIColor.black.cgColor
           menuCard.layer.shadowOpacity = 0.5
           menuCard.layer.masksToBounds = true
           menuCard.layer.cornerRadius = 10
    }
    
    func toggleMenu(){
      
        UIView.animate(withDuration: 0.5) {
            let alpha = !self.menuCard.isHidden ? CGFloat(0.0) : CGFloat(1.0)
            self.menuCard.isHidden.toggle()
            self.menuCard.alpha = alpha
            self.addCarByTextButton.alpha = alpha
            self.addCarByTextButton.isHidden.toggle()
            self.addCarByVinButton.alpha = alpha
            self.addCarByVinButton.isHidden.toggle()
            self.editCurrentCarButton.alpha = alpha
            self.editCurrentCarButton.isHidden.toggle()
        }
        
    }
    
    func setPickerViewToCarValue(){
        guard let car = CarController.shared.selectedCar else {return}
        var odomenterAsStringArray = Array("\(Int(car.odometer))")
        print(odomenterAsStringArray)
        while odomenterAsStringArray.count < 7 {
            odomenterAsStringArray.insert("0", at: 0)
        }
        print(odomenterAsStringArray)
        UIView.animate(withDuration: 2) {
            self.odometerPicker.selectRow(Int(String(odomenterAsStringArray[0])) ?? 0, inComponent: 0, animated: true)
            self.odometerPicker.selectRow(Int(String(odomenterAsStringArray[1])) ?? 0, inComponent: 1, animated:  true)
            self.odometerPicker.selectRow(Int(String(odomenterAsStringArray[2])) ?? 0, inComponent: 2, animated: true)
            self.odometerPicker.selectRow(Int(String(odomenterAsStringArray[3])) ?? 0, inComponent: 3, animated: true)
            self.odometerPicker.selectRow(Int(String(odomenterAsStringArray[4])) ?? 0, inComponent: 4, animated: true)
            self.odometerPicker.selectRow(Int(String(odomenterAsStringArray[5])) ?? 0, inComponent: 5, animated: true)
            self.odometerPicker.selectRow(Int(String(odomenterAsStringArray[6])) ?? 0, inComponent: 6, animated: true)
        }
        
    }
    func initialSetUP(){
        odometerPicker.delegate = self
        odometerPicker.dataSource = self
        odometerPicker.isUserInteractionEnabled = false
        carSelectionTableView.delegate = self
        carSelectionTableView.dataSource = self
        carSelectionTableView.isHidden = true
        guard let car = CarController.shared.selectedCar else {return}
        currentCarButton.setTitle(car.name, for: .normal)
        currentCarSelected = car
        updateTableViewFrame()
        setTextFields()
        self.carSelectionTableView.tableFooterView = UIView()
    }
    
    func updateTableViewFrame(){
        if isInCarSelectionMode{
            view.blurView(style: .extraLight)
            view.bringSubviewToFront(carSelectionTableView)
        } else {
            view.removeBlur()
        }
        UIView.animate(withDuration: 0.5) {
            self.carSelectionTableView.frame = self.tableViewSize
        }
        if isInCarSelectionMode{
            
            carSelectionTableView.layer.backgroundColor = UIColor.clear.cgColor
            carSelectionTableView.layer.cornerRadius = 10
        } else {
            
            carSelectionTableView.layer.backgroundColor = UIColor.clear.cgColor
        }
    }
    
    func setTextFields(){
        guard let selectedCar = currentCarSelected else {return}
        ownerLabel.text = selectedCar.ownerName
        makeLabel.text = selectedCar.make
        if odometerPicker.isUserInteractionEnabled{
            savebutton.setTitle("Save", for: .normal)
        } else {
            savebutton.setTitle("Edit", for: .normal)
        }
    }
    
    //    func presentOptions(){
    //        let alertController = UIAlertController(title: "Add a car", message: "How would you like to add your vehicle?", preferredStyle: .actionSheet)
    //        let button1 = UIAlertAction(title: "Manual Key in", style: .default) { (_) in
    //            self.performSegue(withIdentifier: "manual", sender: nil)
    //        }
    //        let button2 = UIAlertAction(title: "Look up by Vin", style: .default) { (_) in
    //            self.performSegue(withIdentifier: "auto", sender: nil)
    //        }
    //        let button3 = UIAlertAction(title: "Edit current car", style: .default) { (_) in
    //            DispatchQueue.main.async {
    //                self.performSegue(withIdentifier: "manuelEdit", sender: nil)
    //            }
    //        }
    //        let cancel = UIAlertAction(title: "Cancel", style: .default) { (_) in
    //        }
    //        alertController.addAction(button1)
    //        alertController.addAction(button2)
    //        if let _ = CarController.shared.selectedCar{
    //            alertController.addAction(button3)
    //        }
    //
    //        alertController.addAction(cancel)
    //        self.present(alertController, animated: true)
    //    }
    
    func odometerResults() -> Int {
        var placeholder: [Int] = []
        for component in 0..<odometerPicker.numberOfComponents {
            let number = odometerPicker.selectedRow(inComponent: component)
            placeholder.append(number)
        }
        let odometer = placeholder.reduce(0, {$0*10 + $1})
        return odometer
    }
    
    //MARK: - ACTIONS
    @IBAction func AddACarButtonTapped(_ sender: Any) {
        if !isInCarSelectionMode{
              toggleMenu()
            if menuCard.isHidden{
                view.removeBlur()
            } else {
                view.blurView(style: .extraLight)
                view.bringSubviewToFront(menuCard)
            }
        }
      
    }
    
    @IBAction func presentCarsButtonTapped(_ sender: Any) {
        if CarController.shared.garage?.count ?? 0 >= 2{
        carSelectionTableView.isHidden = false
        isInCarSelectionMode.toggle()
        updateTableViewFrame()
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let car = CarController.shared.selectedCar else {return}
        if odometerPicker.isUserInteractionEnabled == true {
            CarController.shared.updateOdometer(car: car, odometer: Double(odometerResults())) { (_) in
            }
        }
        odometerPicker.isUserInteractionEnabled.toggle()
        setTextFields()
    }
    
    
    @IBAction func addCarByVinTapped(_ sender: Any) {
        toggleMenu()
        self.performSegue(withIdentifier: "auto", sender: nil)
    }
    
    
    @IBAction func addCarByTextTapped(_ sender: Any) {
        toggleMenu()
        self.performSegue(withIdentifier: "manual", sender: nil)
        
    }
    
    
    @IBAction func editCarButtonTapped(_ sender: Any) {
        toggleMenu()
        self.performSegue(withIdentifier: "manuelEdit", sender: nil)
    }
    
    @IBAction func screenTapped(_ sender: Any) {
        if !menuCard.isHidden{
            toggleMenu()
            view.removeBlur()
        }
    }
    
    
    
    //MARK: - NAVIGATION
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "manuelEdit"{
            if let destination = segue.destination as? AddCarTableViewController{
                guard let car = CarController.shared.selectedCar else {return}
                destination.carToEdit = car
            }
        }
    }
    
    
}
//MARK: - EXTENSIONS

extension MyGarageViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let garage = CarController.shared.garage else {return 1}
        return garage.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "car", for: indexPath) as? MyGarageTableViewCell else {return UITableViewCell()}
        cell.delegate = self
        guard let garage = CarController.shared.garage else {return UITableViewCell()}
        let car = garage[indexPath.row]
        cell.updateCell(car: car)
        cell.carIndex = indexPath
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return makeLabel.frame.height * 1.3
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
}
extension MyGarageViewController: MyGarageTableViewCellDelegate{
    func carSelectionButtonTapped(_ sender: MyGarageTableViewCell) {
        isInCarSelectionMode.toggle()
        updateTableViewFrame()
        guard let car = sender.carInCell else {return}
        guard let indexPath = sender.carIndex else {return}
        currentCarSelected = car
        CarController.shared.selectedCar = car
        self.carSelectionTableView.scrollToRow(at: indexPath, at: .top, animated: true)
        setPickerViewToCarValue()
        odometerPicker.isUserInteractionEnabled = false
        setTextFields()
        carSelectionTableView.reloadData()
        carSelectionTableView.isHidden = true
        currentCarButton.setTitle(car.name, for: .normal)
    }
}
extension MyGarageViewController: UIPickerViewDataSource, UIPickerViewDelegate{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 7
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.odometer.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        return
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(row)
    }
    
    
}
extension UIView {
    func blurView(style: UIBlurEffect.Style) {
        var blurEffectView = UIVisualEffectView()
        let blurEffect = UIBlurEffect(style: style)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        addSubview(blurEffectView)
    }
    
    func removeBlur() {
        for view in self.subviews {
            if let view = view as? UIVisualEffectView {
                view.removeFromSuperview()
            }
        }
    }
}
