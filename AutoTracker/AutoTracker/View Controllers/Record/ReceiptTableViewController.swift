//
//  ReceiptTableViewController.swift
//  AutoTracker
//
//  Created by Sam LoBue on 10/18/19.
//  Copyright © 2019 Ian Hall. All rights reserved.
//

import UIKit

class ReceiptTableViewController: UITableViewController {
    
    // MARK: - PROPERTIES
    var maintenance: [Maintanence]? {
        let list = CarController.shared.organizeAndReturnReceipts()
        return list
    }
    
    var photoToSend: UIImage?
    
    // MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
        
    }
    
    // MARK: - TABLE VIEW DATA SOURCE
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let maintenance = maintenance else { return 0 }
        return maintenance.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "detail", for: indexPath) as? MaintenanceTableViewCell else { return UITableViewCell() }
        guard let maintenance = maintenance else { return UITableViewCell() }
        cell.update(maintenance: maintenance[indexPath.row])
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "receiptImage"{
            if let destination = segue.destination as? ReceiptPhotoViewController{
                if let index = tableView.indexPathForSelectedRow{
                    guard let main = maintenance else {return}
                    let selectedMain = main[index.row]
                    destination.image = selectedMain.photo
                }
            }
        }
    }
}
