//
//  MaintanenceDetailTableViewController.swift
//  AutoTracker
//
//  Created by Ian Hall on 10/7/19.
//  Copyright © 2019 Ian Hall. All rights reserved.
//

import UIKit

class MaintanenceDetailTableViewController: UITableViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    var maintainenceList: [Maintanence]{
        return CarController.shared.organizeAndReturnMaintainenceList()
    }
    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if maintainenceList.count == 0{
            return 1
        }
        return maintainenceList.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "detail", for: indexPath) as? MaintainenceDetailTableViewCell else {return UITableViewCell()}
        if maintainenceList.count == 0{
            cell.cellLabel.text = "No maintenance Items for this car"
            return cell
        }
        let maintenance = maintainenceList[indexPath.row]
        guard let date = maintenance.dueOn else {return UITableViewCell()}
        let dueDate = DateHelper.shared.stringForMaintenanceDate(date: date)
        
        cell.cellLabel.text = "\(maintenance.maintanenceRequired ?? "")|\(dueDate)"
        // Configure the cell...

        return cell
    }



    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }



    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "edit"{
            if let indexPath = tableView.indexPathForSelectedRow{
                if let destinationVC = segue.destination as? AddMaintenanceTableViewController{
                    let maintenance = maintainenceList[indexPath.row]
                    destinationVC.maintenance = maintenance
                }
            }
        }
    }

}
