//
//  HelperService.swift
//  LaundryDay
//
//  Created by MBP03 on 2018. 5. 22..
//  Copyright © 2018년 MBP03. All rights reserved.
//

import Foundation
import FirebaseStorage
import ProgressHUD

class HelperService {
    static func updataToServer(data: Data, productName: String, onSuccess: @escaping () -> Void) {
        
        let imageString = NSUUID().uuidString
        let storageRef = Storage.storage().reference(forURL: Config.STROAGE_ROOT_REF).child("items").child(imageString)
        storageRef.putData(data, metadata: nil) { (metadata,error) in
            if error != nil {
                ProgressHUD.showError(error?.localizedDescription)
                return
            }
            let productImgURL = metadata?.downloadURL()?.absoluteString
            self.sendDataToDatabase(productImgURL: productImgURL!, productName: productName, onSuccess: onSuccess)

        }
    }
    static func sendDataToDatabase(productImgURL:String, productName:String, onSuccess: @escaping ()->Void) {
        let newClothesID = Api.Clothes.REF_ITEMS.childByAutoId().key
        let newClothesRef = Api.Clothes.REF_ITEMS.child(newClothesID)
        guard let currentUser = Api.User.CURRENT_USER else{
            return
    }
        let currentUserID = currentUser.uid
        newClothesRef.setValue(["productImgUrl":productImgURL, "productName": productName, "uid": currentUserID], withCompletionBlock: {(error, ref) in
            if error != nil {
                ProgressHUD.showError(error?.localizedDescription)
                return
            }
            
            let myClothesRef = Api.MyItems.REF_MYITEMS.child(currentUserID).child(newClothesID)
            myClothesRef.setValue(true, withCompletionBlock: {(error,ref) in
                if error != nil {
                    ProgressHUD.showError(error?.localizedDescription)
                    return
                }
            })
        
            
            ProgressHUD.showSuccess("Success")
            onSuccess()
        })
        
    }
}
