//
//  ImageDisplayViewController.swift
//  AutoTracker
//
//  Created by Ian Hall on 10/16/19.
//  Copyright © 2019 Ian Hall. All rights reserved.
//

import UIKit

class ImageDisplayViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var imageToDisplay: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let image = imageToDisplay else {return}
        imageView.image = image
    }
}
