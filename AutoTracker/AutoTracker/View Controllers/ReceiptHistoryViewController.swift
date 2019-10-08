//
//  ReceiptHistoryViewController.swift
//  AutoTracker
//
//  Created by Sam LoBue on 10/7/19.
//  Copyright © 2019 Ian Hall. All rights reserved.
//

import UIKit

class ReceiptHistoryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    // MARK: - OUTLETS
    
    @IBOutlet weak var receiptCollectionView: UICollectionView!
    
    // MARK: - PROPERTIES
    private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    
    private let itemsPerRow: CGFloat = 4
    
    // MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        receiptCollectionView.delegate = self
        receiptCollectionView.dataSource = self
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
            // the default direction is right
            
            let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
            leftSwipe.direction = .left

            
            view.addGestureRecognizer(rightSwipe)
            view.addGestureRecognizer(leftSwipe)

        }
        
        @objc func handleSwipe(sender: UISwipeGestureRecognizer) {
            if sender.state == .ended {
                switch sender.direction {
                case .right:
                    view.backgroundColor = .red
                case .left:
                    view.backgroundColor = .blue
                default:
                    break
                }
            }
    }
    
    // MARK: - ACTIONS
    
    @IBAction func swipeToScroll(_ sender: Any) {
        
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

extension ReceiptHistoryViewController {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "receiptCell", for: indexPath) as? ReceiptCollectionViewCell else { return UICollectionViewCell() }
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 12
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow

        return CGSize(width: widthPerItem, height: widthPerItem)

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
}
