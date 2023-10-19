//
//  UserApi.swift
//  MyInstaStory
//
//  Created by park kyung suk on 2017/08/10.
//  Copyright © 2017年 park kyung suk. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseAuth

class UserApi {
    
    var REF_USERS = Database.database().reference().child("users")
    
    func observeUser(withId: String, completion: @escaping (User)->()) {
        REF_USERS.child(withId).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dic = snapshot.value as? [String: Any] {
                let user = User.transformUser(dic: dic, key: snapshot.key)
                completion(user)
            }
        })
    }
    
    func observeCurrentUser(completion: @escaping (User)->()) {
        guard let currentUser = Auth.auth().currentUser else { return }
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
    
    //textでuserをquery
    func queryUsers(withText text: String, completion: @escaping (User)->()) {
        REF_USERS.queryOrdered(byChild: "username_lowercase")
            .queryStarting(atValue: text)
            .queryEnding(atValue: text+"\u{f8ff}")
            .queryLimited(toLast: 10)
            .observeSingleEvent(of: .value, with: { (snapshot) in
                
            snapshot.children.forEach({ (s) in
                let child = s as! DataSnapshot
                if let dic = child.value as? [String: Any] {
                    
                    let user = User.transformUser(dic: dic, key: child.key)
                    completion(user)
                }
            })
        })
    }
    
    //retrun currentUser
    var CURRENT_USER: FirebaseAuth.User? {
        if let currentUSer = Auth.auth().currentUser {
            return currentUSer
        }
        return nil
    }
    
    //Return CurrentUserRef
    var REF_CURRENT_USER: DatabaseReference? {
        guard let currentUser = Auth.auth().currentUser else { return nil }
        return REF_USERS.child(currentUser.uid)
    }
    
}
