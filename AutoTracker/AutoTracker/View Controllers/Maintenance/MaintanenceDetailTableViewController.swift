//
//  MaintanenceDetailTableViewController.swift
//  AutoTracker
//
//  Created by Ian Hall on 10/7/19.
//  Copyright © 2019 Ian Hall. All rights reserved.
//

import UIKit

class MaintanenceDetailTableViewController: UITableViewController {
    
    var maintainenceList: [Maintanence]{
        return CarController.shared.organizeAndReturnMaintainenceList()
    }
    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return maintainenceList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "detail", for: indexPath) as? MaintainenceDetailTableViewCell else {return UITableViewCell()}
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


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
