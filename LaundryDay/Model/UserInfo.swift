//
//  User.swift
//  LaundryDay
//
//  Created by MBP03 on 2018. 5. 21..
//  Copyright © 2018년 MBP03. All rights reserved.
//

import Foundation
class UserInfo {
    var profileImageUrl: String?
    var userName: String?
    //var uid: String?
}

extension UserInfo {
    static func transformUser(dict:[String:Any]) -> UserInfo {
        let user = UserInfo()
        user.userName = dict["userName"] as? String
        user.profileImageUrl = dict["profileImgURL"] as? String
        //user.uid = dict["uid"] as? String
        
        return user
    }
    
}
