//
//  AuthService.swift
//  MyInstaStory
//
//  Created by park kyung suk on 2017/08/05.
//  Copyright © 2017年 park kyung suk. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class AuthService {
    
    //static var shared = AuthService()
    
    static func signIn(email: String, password: String, completion: @escaping ()->(), onError: @escaping (_ errorMessage: Error?)->()) {
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            
            if error != nil {
                onError(error)
                return
            }
            completion()
        })
    }
    
    static func signUp(username: String, email: String, password: String, imageData: Data, completion: @escaping ()->(), onError: @escaping (_ errorMessage: Error?)->()) {
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                onError(error)
                return
            }
            
            guard let uid = user?.uid else { return }
            //ストレージRef
            let storageRef = FIRStorage.storage().reference().child(PROFILE_IMAGES).child(uid)
            
            //ストレージにprofileImageを保存
            storageRef.put(imageData, metadata: nil, completion: { (metaData, error) in
                
                if error != nil {
                    print("Some Error to put strorage a profileImage :\(error!)")
                    return
                }
                
                let profileImageUrl = metaData?.downloadURL()?.absoluteString
                
                //データベースにユーザー情報を保存
                self.setUserInfomationToDataBase(profileImageUrl: profileImageUrl!,
                                                 username: username,
                                                 email: email, uid: uid, completion: completion)
            })
        })
    }
    static private func setUserInfomationToDataBase(profileImageUrl: String, username: String, email: String, uid: String, completion: @escaping ()->()) {
        let ref = FIRDatabase.database().reference()
        let userRef = ref.child("users")
        let newUserRef = userRef.child(uid)
        newUserRef.setValue(["username": username,
                             "email": email,
                             "profileImageUrl": profileImageUrl])
        completion()
    }
    
    
}