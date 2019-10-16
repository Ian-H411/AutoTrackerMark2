//
//  ReceiptCollectionViewCell.swift
//  AutoTracker
//
//  Created by Sam LoBue on 10/7/19.
//  Copyright © 2019 Ian Hall. All rights reserved.
//

import UIKit

class ReceiptCollectionViewCell: UICollectionViewCell {
    
    // MARK: - OUTLETS

    @IBOutlet weak var receiptImageView: UIImageView!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var pricePerGallonLabel: UILabel!
    
    // MARK: - PROPERTIES
    
    var receipt: Receipt? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - FUNCTION
    
    func updateViews() {
        guard let receipt = receipt else { print("no RECEIPT"); return }
        self.backgroundColor = .lightGray
        
        
        totalLabel.text = receipt.total
        pricePerGallonLabel.text = receipt.ppg
        receiptImageView.image = receipt.photo
//        if let photo = receipt.photo, let resized = resizeImage(photo) {
//            receiptImageButton.setBackgroundImage(resized, for: .normal)
//        } else {
//            receiptImageButton.setBackgroundImage(nil, for: .normal)
//        }
    }
    
//    func resizeImage(_ image: UIImage) -> UIImage? {
//        let newWidth = receiptImageButton.bounds.width
//        let scale = newWidth / image.size.width
//        let newHeight = image.size.height * scale
//        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
//        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
//        let newImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        return newImage
//    }
}
