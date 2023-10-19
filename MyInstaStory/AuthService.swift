//
//  AuthService.swift
//  MyInstaStory
//
//  Created by park kyung suk on 2017/08/05.
//  Copyright © 2017年 park kyung suk. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import ProgressHUD

class AuthService {
    
    //static var shared = AuthService()
    
    static func signIn(email: String, password: String, completion: @escaping ()->(), onError: @escaping (_ errorMessage: Error?)->()) {
        
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            
            if error != nil {
                onError(error)
                return
            }
            completion()
        })
    }
    
    static func signUp(username: String, email: String, password: String, imageData: Data, completion: @escaping ()->(), onError: @escaping (_ errorMessage: Error?)->()) {
        
        //Authenticationにユーザーを登録
        Auth.auth().createUser(withEmail: email, password: password, completion: { (result, error) in
            if error != nil {
                onError(error)
                return
            }
            
            guard let uid = result?.user.uid else { return }
            //ストレージRef
            let storageRef = Storage.storage().reference(withPath: "/\(PROFILE_IMAGES)/\(uid)")
            
            //ストレージにユーザーのprofileImageを保存
            storageRef.putData(imageData, completion: { (metaData, error) in
                
                if error != nil {
                    print("Some Error to put strorage a profileImage :\(error!)")
                    return
                }
                
                storageRef.downloadURL { url, _ in
                    guard let urlString = url?.absoluteString else { return }
                    //データベースにユーザー情報を保存
                    self.setUserInfomationToDataBase(profileImageUrl: urlString,
                                                     username: username,
                                                     email: email, uid: uid, completion: completion)
                }
            })
        })
    }
    
    
    static func updateUserInfo(username: String, email: String, imageData: Data, onSuccess: @escaping ()->(), onError: @escaping (_ errorMessage: String?)->()) {
        
        ProgressHUD.progress(0.15)
        
        //authticationのuserのemailをupdate後、databaseのuser情報をupdateする
        Api.User.CURRENT_USER?.updateEmail(to: email, completion: { error in
            if error != nil {
                onError(error?.localizedDescription)
            } else {
                
                guard let uid = Api.User.CURRENT_USER?.uid else { return }
                let storageRef = Storage.storage().reference(withPath: "/\(PROFILE_IMAGES)/\(uid)")
                
                
                storageRef.putData(imageData) { (metaData, error) in
                    if error != nil {
                        return
                    }
                    
                    storageRef.downloadURL { url, _ in
                        guard let urlString = url?.absoluteString else { return }
                        updateDatabse(profileImageUrl: urlString, username: username, email: email, onSuccess: onSuccess, onError: onError)

                    }
                }
            }
        })
    }
    
    static func updateDatabse(profileImageUrl: String, username: String, email: String, onSuccess: @escaping ()->(),
                              onError: @escaping (_ errorMessage: String?)->()) {
        
        let dic = ["profileImageUrl": profileImageUrl,
                   "username": username,
                   "username_lowercase": username.lowercased(),
                   "email": email
        ]
        
        //DB内のUserのカレントユーザー情報をアップデートする
        Api.User.REF_CURRENT_USER?.updateChildValues(dic, withCompletionBlock: { (error, ref) in
            if error != nil {
                onError(error?.localizedDescription)
            } else {
                onSuccess()
            }
        })
    }
    
    static private func setUserInfomationToDataBase(profileImageUrl: String, username: String, email: String, uid: String, completion: @escaping ()->()) {
        let ref = Database.database().reference()
        let userRef = ref.child("users")
        let newUserRef = userRef.child(uid)
        newUserRef.setValue(["username": username,
                             "username_lowercase": username.lowercased(),
                             "email": email,
                             "profileImageUrl": profileImageUrl])
        completion()
    }
    
    static func logOut(onSuccess: @escaping ()->(), onError: @escaping (_ errorMessage: String)->()) {
        
        do {
            try Auth.auth().signOut()
            onSuccess()
        } catch let error {
            onError(error.localizedDescription)
        }
    }
    
    
    
    
    
    
    
}
