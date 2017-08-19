//
//  HelperService.swift
//  MyInstaStory
//
//  Created by park kyung suk on 2017/08/13.
//  Copyright © 2017年 park kyung suk. All rights reserved.
//

import Foundation
import FirebaseStorage
import FirebaseDatabase

class HelperService {
    
    static func uploadDataToServer(data: Data, caption: String, onSuccess: @escaping ()->()) {
        
        //postImageのuidを自動生成
        let photoId = NSUUID().uuidString
        //ストレージRef
        let storageRef = FIRStorage.storage().reference().child(POSTS).child(photoId)
        //ストレージにprofileImageを保存
        storageRef.put(data, metadata: nil) { (metaData, error) in
            
            if error != nil {
                ProgressHUD.showError(error!.localizedDescription)
                return
            }
            let photoUrl = metaData?.downloadURL()?.absoluteString
            //データベースにpostを保存
            self.sendDataToDataBase(photoUrl: photoUrl!, caption: caption, onSucess: onSuccess)
        }
    }
    static private func sendDataToDataBase(photoUrl: String, caption: String, onSucess: @escaping ()->()) {
        
        let newPostId = Api.Post.REF_POSTS.childByAutoId().key
        let newPostRef = Api.Post.REF_POSTS.child(newPostId)
        
        guard let currentUserId = Api.User.CURRENT_USER?.uid else { return }
        
        newPostRef.setValue(["userId": currentUserId,
                             "photoUrl": photoUrl,
                             "likeCount": 0,
                             "captionText": caption]) { (error, ref) in
                                
                                if error != nil {
                                    ProgressHUD.showError(error!.localizedDescription)
                                    return
                                }
                                
                                //feed内にも格納
                                FIRDatabase.database().reference().child("feed").child(Api.User.CURRENT_USER!.uid).child(newPostId).setValue(true)
                                
                                
                                //send postしたrefをmypostsにもupdateする（profileVCにてpost一覧を表示するため）
                                let myPostRef = Api.MyPosts.REF_MYPOSTS.child(currentUserId).child(newPostId)
                                myPostRef.setValue(true, withCompletionBlock: { (error, ref) in
                                    
                                    if error != nil {
                                        ProgressHUD.showError(error!.localizedDescription)
                                        return
                                    }
                                })
                                ProgressHUD.showSuccess("Success")
                                onSucess()
        }
    }
}


















