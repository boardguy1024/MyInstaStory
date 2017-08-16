//
//  UserApi.swift
//  MyInstaStory
//
//  Created by park kyung suk on 2017/08/10.
//  Copyright © 2017年 park kyung suk. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

class UserApi {
    
    var REF_USERS = FIRDatabase.database().reference().child("users")
    
    func observeUser(withId: String, completion: @escaping (User)->()) {
        REF_USERS.child(withId).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dic = snapshot.value as? [String: Any] {
                let user = User.transformUser(dic: dic, key: snapshot.key)
                completion(user)
            }
        })
    }
    
    func observeCurrentUser(completion: @escaping (User)->()) {
        guard let currentUser = FIRAuth.auth()?.currentUser else { return }
        REF_USERS.child(currentUser.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dic = snapshot.value as? [String: Any] {
                let currentUser = User.transformUser(dic: dic, key: snapshot.key)
                completion(currentUser)
            }
        })
    }
    
    func observeUsers(completion: @escaping (User)->()) {
        REF_USERS.observe(.childAdded, with: { (snapshot) in
            if let dic = snapshot.value as? [String: Any] {
                let user = User.transformUser(dic: dic, key: snapshot.key)
                if user.id != Api.User.CURRENT_USER!.uid {
                    completion(user)
                }
            }
        })
    }
    
    //retrun currentUser
    var CURRENT_USER: FIRUser? {
        if let currentUSer = FIRAuth.auth()?.currentUser {
            return currentUSer
        }
        return nil
    }
    
    //Return CurrentUserRef
    var REF_CURRENT_USER: FIRDatabaseReference? {
        guard let currentUser = FIRAuth.auth()?.currentUser else { return nil }
        return REF_USERS.child(currentUser.uid)
    }
    
}
