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
    
    // MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        receiptCollectionView.delegate = self
        // Do any additional setup after loading the view.
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "receiptCell", for: indexPath) as? ReceiptCollectionViewCell else { return UICollectionViewCell() }
        
        return cell
    }
    
}
