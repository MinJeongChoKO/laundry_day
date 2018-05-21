//
//  AuthService.swift
//  LaundryDay
//
//  Created by MBP03 on 2018. 4. 24..
//  Copyright © 2018년 MBP03. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class AuthService {
    
    
    static func signIn(email:String, password: String, onSuccess: @escaping () -> Void, onError: @escaping (_ errorMessage: String?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password, completion: {(user, error) in
            if error != nil {
                onError(error!.localizedDescription)
                return
            }
            onSuccess()
        })
        
    }
    
    static func signUp(username: String, email:String, password: String, contact: String, imageData: Data, onSuccess: @escaping () -> Void, onError: @escaping (_ errorMessage: String?) -> Void) {
        //print(ref.description()) //https://laundryday-4027f.firebaseio.com
        Auth.auth().createUser(withEmail: email, password: password, completion: {(user: User?, error: Error?) in
            if error != nil {
                onError(error!.localizedDescription)
                return
            }
            let uid = user?.uid
            
            //스토리지에 유저 uid로 하위폴더 만들어서 이미지 넣음
            let storageRef = Storage.storage().reference(forURL: Config.STROAGE_ROOT_REF).child("profileImg").child(uid!)
                storageRef.putData(imageData, metadata: nil, completion: {(metadata, error) in
                    if error != nil {
                        return
                    }
                    let profileImgURL = metadata?.downloadURL()?.absoluteString
                    
                    self.setUserInfo(userName: username, email: email, contact: contact, profileImgURL: profileImgURL!, uid: uid!, onSuccess: onSuccess)
                })
            
            
            
        })
    }
    
    static func setUserInfo(userName: String, email: String, contact: String, profileImgURL: String, uid: String, onSuccess: @escaping () -> Void) {
        let ref = Database.database().reference()
        let usersRef = ref.child("users")
        let newUserRef = usersRef.child(uid)
        newUserRef.setValue(["userName": userName, "email": email, "contact": contact, "profileImgURL": profileImgURL])
        onSuccess()
    }
    
    static func logout(onSuccess: @escaping () -> Void, onError: @escaping (_ errorMessage: String?) -> Void) {
        do {
        try Auth.auth().signOut()
        onSuccess()
        } catch let logOutError {
        onError(logOutError.localizedDescription)
        }
    }
    
    
}

