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
    
    @IBOutlet weak var engineTypeLabel: AutoTrackerLabel!
    
    @IBOutlet weak var yearLabel: AutoTrackerLabel!
    
    @IBOutlet weak var modelLabel: AutoTrackerLabel!
    
    @IBOutlet weak var makeLabel: AutoTrackerLabel!
    
    @IBOutlet weak var ownerLabel: AutoTrackerLabel!
    
    @IBOutlet weak var vinLabel: AutoTrackerLabel!
    
    
    @IBOutlet weak var carSelectionTableView: UITableView!
    
    //MARK: - Needed Variables
    
    var isInCarSelectionMode:Bool = false
    
    var currentCarSelected: Car?
    
    
    // programatically creates a cgrect that we can set the tableView height to
    var tableViewSize:CGRect{
        if isInCarSelectionMode{
            let x = carSelectionTableView.frame.origin.x
            let y = carSelectionTableView.frame.origin.y
            let width = carSelectionTableView.frame.width
            var contentSize = 81
            if let garage = CarController.shared.garage {
                contentSize = 81 * garage.count
            }
            let height = CGFloat( contentSize )
            return CGRect(x: x, y: y, width: width, height: height)
        } else {
            let x = carSelectionTableView.frame.origin.x
            let y = carSelectionTableView.frame.origin.y
            let width = carSelectionTableView.frame.width
            let height = CGFloat(81)
            return CGRect(x: x, y: y, width: width, height:height)
        }
    }
    
    //MARK: - LIFECYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        carSelectionTableView.delegate = self
        carSelectionTableView.dataSource = self
        guard let car = CarController.shared.selectedCar else {return}
        currentCarSelected = car
        updateTableViewFrame()
        setTextFields()
     
    }
    
    //MARK: - HELPER FUNCTIONS
    
    func updateTableViewFrame(){
        UIView.animate(withDuration: 0.5) {
            self.carSelectionTableView.frame = self.tableViewSize
        }
        if isInCarSelectionMode{
            view.bringSubviewToFront(carSelectionTableView)
        } else {
            view.addSubview(carSelectionTableView)
        }
    }
    
    func setTextFields(){
        guard let selectedCar = currentCarSelected else {return}
        ownerLabel.text = selectedCar.ownerName
        makeLabel.text = selectedCar.make
        modelLabel.text = selectedCar.model
        yearLabel.text = selectedCar.year
        engineTypeLabel.text = selectedCar.engine
        vinLabel.text = selectedCar.vin
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
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
    }
}
