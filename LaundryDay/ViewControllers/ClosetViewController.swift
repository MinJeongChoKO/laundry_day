//
//  ClosetViewController.swift
//  LaundryDay
//
//  Created by MBP03 on 2018. 4. 14..
//  Copyright © 2018년 MBP03. All rights reserved.
//

import UIKit
import FirebaseDatabase
import SDWebImage

class ClosetViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var items = [Clothes]()
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        
        loadData()
    }

    func loadData() {
        Database.database().reference().child("clothes").observe(.childAdded) {snapshot in
            if let dict = snapshot.value as? [String:Any] {
                let newClothes = Clothes.transformClothes(dict: dict)
                self.items.append(newClothes)
                self.collectionView.reloadData()
            }
        }
        
    }

}

extension ClosetViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "clothes", for: indexPath) as! ClosetCollectionViewCell
        let item = items[indexPath.row]
        cell.item = item
        
        return cell
    }
}

