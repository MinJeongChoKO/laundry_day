//
//  ClothesApi.swift
//  LaundryDay
//
//  Created by MBP03 on 2018. 5. 22..
//  Copyright © 2018년 MBP03. All rights reserved.
//

import Foundation
import FirebaseDatabase
class ClothesApi {
    let REF_ITEMS = Database.database().reference().child("items")
    
    func observeClothes(withId id: String, completion: @escaping (Clothes)-> Void) {
        REF_ITEMS.child(id).observeSingleEvent(of: .value, with: {snapshot in
            if let dict = snapshot.value as? [String: Any] {
                let clothes = Clothes.transformClothes(dict: dict, key: snapshot.key)
                completion(clothes)
            }
        })
        
    }
}
