//
//  ClosetViewController.swift
//  LaundryDay
//
//  Created by MBP03 on 2018. 4. 14..
//  Copyright © 2018년 MBP03. All rights reserved.
//

import UIKit
import SDWebImage

class ClosetViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var user: UserInfo!
    var items = [Clothes]()
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        fetchUser()
        fetchMyItems()
        //loadData()
    }
    
    func fetchUser() {
        Api.User.observeCurrentUser(completion: {user in
            self.user = user
            self.collectionView.reloadData()
        })
    }
    
    func fetchMyItems() {
        guard let currentUser = Api.User.CURRENT_USER else {
            return
        }
        Api.MyItems.REF_MYITEMS.child(currentUser.uid).observe(.childAdded, with: {snapshot in
            Api.Clothes.observeClothes(withId: snapshot.key, completion: {clothes in
                self.items.append(clothes)
                self.collectionView.reloadData()
            })
        })
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

extension ClosetViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    //사진 사이즈
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width / 3, height: 150)
    }
}
