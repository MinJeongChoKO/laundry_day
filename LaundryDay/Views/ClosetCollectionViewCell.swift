//
//  ClosetCollectionViewCell.swift
//  LaundryDay
//
//  Created by MBP03 on 2018. 5. 17..
//  Copyright © 2018년 MBP03. All rights reserved.
//

import UIKit

class ClosetCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
    var item: Clothes? {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        productName.text = item?.productName
        if let photoUrlString = item?.productImgUrl {
            let photoUrl = URL(string: photoUrlString)
            productImageView.sd_setImage(with: photoUrl)
        }
    }
}
