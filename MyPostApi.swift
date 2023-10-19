//
//  MyPostApi.swift
//  MyInstaStory
//
//  Created by park kyung suk on 2017/08/12.
//  Copyright © 2017年 park kyung suk. All rights reserved.
//

import Foundation
import FirebaseDatabase

class MyPostApi {
    
    var REF_MYPOSTS = Database.database().reference().child("myPosts")
    
    func fetchMyPosts(userId: String, completion: @escaping (String)->()) {
        REF_MYPOSTS.child(userId).observe(.childAdded, with: { (snapshot) in
            
            completion(snapshot.key)
        })
    }
    
    func fetchCountMyPosts(userId: String, completion: @escaping (Int)->()) {
        REF_MYPOSTS.child(userId).observe(.value, with: { (snapshot) in
            completion(Int(snapshot.childrenCount))
        })
    }
}
