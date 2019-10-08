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
        guard let receipt = receipt else { return }
        
        receiptImageView.image = receipt.photo
        // Add total to model?
        // Add price per gallon to model?
    }
}
