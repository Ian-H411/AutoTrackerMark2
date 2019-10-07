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
    
    @IBOutlet weak var carSelectionTableView: UITableView!
    
    //MARK: - Needed Variables
    
    var isInCarSelectionMode:Bool = false
    
    var currentCarSelected:Car?
    
    // programatically creates a cgrect that we can set the tableView height to
    var tableViewSize:CGRect{
        if isInCarSelectionMode{
            let x = carSelectionTableView.frame.origin.x
            let y = carSelectionTableView.frame.origin.y
            let width = carSelectionTableView.frame.width
            let height = carSelectionTableView.contentSize.height
            return CGRect(x: x, y: y, width: width, height: height)
        } else {
            let x = carSelectionTableView.frame.origin.x
            let y = carSelectionTableView.frame.origin.y
            let width = carSelectionTableView.frame.width
            let height = CGFloat(70)
            return CGRect(x: x, y: y, width: width, height:height)
        }
    }
    
    //MARK: - LIFECYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        carSelectionTableView.delegate = self
        updateTableViewFrame()
    }
    
    //MARK: - HELPER FUNCTIONS
    
    func updateTableViewFrame(){
        carSelectionTableView.frame = tableViewSize
        if isInCarSelectionMode{
            view.bringSubviewToFront(carSelectionTableView)
        } else {
            view.addSubview(carSelectionTableView)
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
extension MyGarageViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "car", for: indexPath) as? MyGarageTableViewCell else {return UITableViewCell()}
        
        return cell
    }
    
    
}
extension MyGarageViewController: MyGarageTableViewCellDelegate{
    func carSelectionButtonTapped(_ sender: MyGarageTableViewCell) {
        updateTableViewFrame()
        guard let car = sender.carInCell else {return}
        currentCarSelected = car
    }
    
    
}
