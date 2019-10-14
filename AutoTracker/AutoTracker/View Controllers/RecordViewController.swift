//
//  RecordViewController.swift
//  AutoTracker
//
//  Created by Sam LoBue on 10/7/19.
//  Copyright © 2019 Ian Hall. All rights reserved.
//

import UIKit

class RecordViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if CarController.shared.selectedCar == nil {
            enterCarAlert()
        }
        
        // Do any additional setup after loading the view.
    }
    

    // MARK: - FUNCTIONS
    
    func enterCarAlert() {
        let alertController = UIAlertController(title: "Enter a car before updating its miles", message: nil, preferredStyle:  .alert)
        let action = UIAlertAction(title: "Okay", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
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
