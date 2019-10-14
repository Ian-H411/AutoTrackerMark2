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
    

    @IBOutlet weak var currentCarButton: AutoTrackerButtonGreen!
    
    @IBOutlet weak var odometerPicker: UIPickerView!
    
    @IBOutlet weak var makeLabel: AutoTrackerLabel!
    
    @IBOutlet weak var ownerLabel: AutoTrackerLabel!
    
    
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var carSelectionTableView: UITableView!
    
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
        odometerPicker.delegate = self
        odometerPicker.dataSource = self
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        carSelectionTableView.reloadData()
    }
    
    //MARK: - HELPER FUNCTIONS
//    
//    func setPickerViewToCarValue(){
//        guard let car = CarController.shared.selectedCar else {return}
//        var numberArray:[Int] = []
//        for digit in string{
//            guard let digitInt = Int(digit) else {return}
//            numberArray.append(digitInt)
//        }
//
//        odometerPicker.selectRow(<#T##row: Int##Int#>, inComponent: <#T##Int#>, animated: <#T##Bool#>)
//    }
    
    func updateTableViewFrame(){
        UIView.animate(withDuration: 0.5) {
            self.carSelectionTableView.frame = self.tableViewSize
        }
        if isInCarSelectionMode{

            carSelectionTableView.layer.borderWidth = 3
            carSelectionTableView.layer.backgroundColor = UIColor.red.cgColor
            carSelectionTableView.layer.cornerRadius = 10
        } else {

            carSelectionTableView.layer.backgroundColor = UIColor.clear.cgColor
            carSelectionTableView.layer.borderWidth = 0
        }
    }
    
    func setTextFields(){
        guard let selectedCar = currentCarSelected else {return}
        ownerLabel.text = selectedCar.ownerName
        makeLabel.text = selectedCar.make
    }
    
    func presentOptions(){
        let alertController = UIAlertController(title: "Add a car", message: "How would you like to add your vehicle?", preferredStyle: .actionSheet)
        let button1 = UIAlertAction(title: "Manual Key in", style: .default) { (_) in
            self.performSegue(withIdentifier: "manual", sender: nil)
        }
        let button2 = UIAlertAction(title: "Look up by Vin", style: .default) { (_) in
            self.performSegue(withIdentifier: "auto", sender: nil)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .default) { (_) in
        }
        alertController.addAction(button1)
        alertController.addAction(button2)
        alertController.addAction(cancel)
        self.present(alertController, animated: true)
    }
    
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
        presentOptions()
    }
    
    @IBAction func presentCarsButtonTapped(_ sender: Any) {
        carSelectionTableView.isHidden = false
        isInCarSelectionMode.toggle()
        updateTableViewFrame()
    }
    
    
}
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
     
        return 81
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
