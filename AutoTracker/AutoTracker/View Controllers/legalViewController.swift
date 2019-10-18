//
//  legalViewController.swift
//  AutoTracker
//
//  Created by Ian Hall on 10/18/19.
//  Copyright © 2019 Ian Hall. All rights reserved.
//

import UIKit

class legalViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    @IBAction func linkToPRivacyPolicyButtonTapped(_ sender: Any) {
        if !Reachability.isConnectedToNetwork(){
            presentNoInternetAlert()
            return
        }
        guard let url = URL(string: "https://sites.google.com/view/autotracker/home") else {return}
        UIApplication.shared.open(url)
    }
    
    func presentNoInternetAlert(){
           let alert = UIAlertController(title: "No Internet", message: "Sorry but this function requires an internet connection.  check your connection and try again", preferredStyle: .alert)
           let okayButton = UIAlertAction(title: "okay", style: .default, handler: nil)
           alert.addAction(okayButton)
           self.present(alert, animated: true)
       }
}
