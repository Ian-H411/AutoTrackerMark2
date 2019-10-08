//
//  OdometerViewController.swift
//  AutoTracker
//
//  Created by Sam LoBue on 10/7/19.
//  Copyright © 2019 Ian Hall. All rights reserved.
//

import UIKit

class OdometerViewController: UIViewController {

    // MARK: - OUTLETS
    @IBOutlet weak var mileageTextField: UITextField!
    
    
    // MARK: - PROPERTIES
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mileageTextField.layer.borderColor = UIColor.black.cgColor
        mileageTextField.layer.borderWidth = 2
        mileageTextField.delegate = self
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

extension OdometerViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("tapped")
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }
}
