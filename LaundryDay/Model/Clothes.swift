//
//  Clothes.swift
//  LaundryDay
//
//  Created by MBP03 on 2018. 5. 17..
//  Copyright © 2018년 MBP03. All rights reserved.
//

import Foundation

class Clothes  {
    var productImgUrl: String?
    var productName: String?
    var uid: String?
    
    
}
extension Clothes {
    static func transformClothes(dict: [String:Any]) -> Clothes {
        let clothes = Clothes()
        clothes.productImgUrl = dict["productImgUrl"] as? String
        clothes.productName = dict["productName"] as? String
        clothes.uid = dict["uid"] as? String
        return clothes
    }
}
/* 다시해야될것같네^^
 내가 올린것만 보여야하니까 구조를 다시 짜야할듯...
 */
