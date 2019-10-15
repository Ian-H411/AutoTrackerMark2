//
//  MaintanenceDetailTableViewController.swift
//  AutoTracker
//
//  Created by Ian Hall on 10/7/19.
//  Copyright © 2019 Ian Hall. All rights reserved.
//

import UIKit

class MaintanenceDetailTableViewController: UITableViewController {
    //MARK: - OUTLETS
    
    @IBOutlet weak var historySegmentedControl: UISegmentedControl!
    
    
    //MARK: - VARIABLES
    
    var displayHistory = false
    
    var dataSource:[Maintanence]{
        let list = CarController.shared.organizeAndReturnMaintainenceList()
        var listHistory:[Maintanence] = []
        var listIncomplete:[Maintanence] = []
        for item in list{
            if item.isComplete{
                listHistory.append(item)
            } else {
                listIncomplete.append(item)
            }
        }
        if displayHistory{
            return listHistory
        } else {
            return listIncomplete
        }
    }
    
    var sendToOdometer: Maintanence?
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "detail", for: indexPath) as? MaintenanceTableViewCell else {return UITableViewCell()}
        let maintenance = dataSource[indexPath.row]
        cell.delegate = self
        cell.update(maintenance: maintenance)
        return cell
    }
    
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let main = dataSource[indexPath.row]
            CarController.shared.deleteMaintenance(maintenance: main)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    //MARK: - ACTIONS
    
    @IBAction func historySegmentedControlTapped(_ sender: Any) {
        displayHistory.toggle()
        tableView.reloadData()
    }
    
    
    //MARK: - HELPERS
    
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "edit"{
            if let destinationVC = segue.destination as? AddMaintenanceTableViewController{
                if let index = tableView.indexPathForSelectedRow {
                    let main = dataSource[index.row]
                    destinationVC.maintenance = main
                }
            }
        } else if segue.identifier == "updateodo" {
            guard let main = sendToOdometer else {return}
            if let destinationVC = segue.destination as? UpdateOdometerViewController {
                destinationVC.maintenance = main
            }
            
        }
    }
    
}
extension MaintanenceDetailTableViewController: MaintenanceTableViewCellDelegate{
    func buttonTapped(_ sender: MaintenanceTableViewCell) {
        guard let maintenance = sender.selectedMaintenance else {return}
        CarController.shared.toggleMaintenanceReminder(maintenance: maintenance)
        if maintenance.isComplete{
            sendToOdometer = maintenance
            self.performSegue(withIdentifier: "updateodo", sender: nil)
        }
        tableView.reloadData()
    }
    
    
}
