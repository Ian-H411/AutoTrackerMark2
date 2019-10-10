//
//  ReceiptHistoryViewController.swift
//  AutoTracker
//
//  Created by Sam LoBue on 10/7/19.
//  Copyright © 2019 Ian Hall. All rights reserved.
//

import UIKit

class ReceiptHistoryViewController: UIViewController {

    // MARK: - OUTLETS
    
    @IBOutlet weak var receiptCollectionView: UICollectionView!
    
    // MARK: - PROPERTIES
    
    private var index = 0
    
    // MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        receiptCollectionView.delegate = self
        receiptCollectionView.dataSource = self
        receiptCollectionView.isUserInteractionEnabled = false
        
        let left = UISwipeGestureRecognizer(target: self, action: #selector(leftSwipe))
        left.direction = .left
        view.addGestureRecognizer(left)
        let right = UISwipeGestureRecognizer(target: self, action: #selector(rightSwipe))
        right.direction = .right
        view.addGestureRecognizer(right)

    }
    
    // MARK: - ACTIONS
    
    @IBAction func swipeToScroll(_ sender: Any) {
        
    }
    
    @IBAction func returnButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - FUNCTIONS
    
    @objc func leftSwipe() {
           print("left")
        if index + 2 < ReceiptController.shared.receipts.count {
               index += 2
               receiptCollectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .left, animated: true)
           }
       }
       
       @objc func rightSwipe() {
           print("right")
           if index - 2 >= 0 {
               index -= 2
               receiptCollectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .left, animated: true)
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

extension ReceiptHistoryViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 2
//    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ReceiptController.shared.receipts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "receiptCell", for: indexPath) as? ReceiptCollectionViewCell else { return UICollectionViewCell() }
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 12
        cell.receipt = ReceiptController.shared.receipts[indexPath.row]
        return cell
    }
    

    

//        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//            let width = self.calculateWith()
//            return CGSize(width: width, height: width)
//        }
//
//        func calculateWith() -> CGFloat {
//            let estimatedWidth = CGFloat(estimateWidth)
//            let cellCount = floor(CGFloat(self.view.frame.size.width / estimatedWidth))
//
//            let margin = CGFloat(cellMarginSize * 2)
//            let width = (self.view.frame.size.width - CGFloat(cellMarginSize) * (cellCount - 1) - margin) / cellCount
//
//            return width
//        }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: (collectionView.bounds.width / 2) - 25, height: (collectionView.bounds.height / 2) - 25)
        print(size)
        return size
    }

//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//    }

}
