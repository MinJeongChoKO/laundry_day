//
//  UserApi.swift
//  LaundryDay
//
//  Created by MBP03 on 2018. 5. 21..
//  Copyright © 2018년 MBP03. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

class UserApi {
    let REF_USERS = Database.database().reference().child("users")
    
    var REF_CURRENT_USER: DatabaseReference? {
        guard let currentUser = Auth.auth().currentUser else{
            return nil
        }
        return REF_USERS.child(currentUser.uid)
    }
    
    var CURRENT_USER: User? {
        if let currentUser = Auth.auth().currentUser {
            return currentUser
        }
        return nil
    }
    
    
    func observeCurrentUser(completion:@escaping (UserInfo) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        REF_USERS.child(currentUser.uid).observeSingleEvent(of: .value, with: { snapshot in
            if let dict = snapshot.value as? [String:Any] {
                let user = UserInfo.transformUser(dict: dict)
                completion(user)
            }
        })
    }
}
