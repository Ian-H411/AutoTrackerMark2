//
//  ReceiptPhotoViewController.swift
//  AutoTracker
//
//  Created by Ian Hall on 10/21/19.
//  Copyright © 2019 Ian Hall. All rights reserved.
//

import UIKit

class ReceiptPhotoViewController: UIViewController {

    
    @IBOutlet weak var receiptImage: UIImageView!
    
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        receiptImage.image = image ?? UIImage(named: "defaultCar")!
    }
    



}
