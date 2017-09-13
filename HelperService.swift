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
    
    static func uploadDataToServer(data: Data, videoUrl: URL? = nil, ratio: CGFloat, caption: String, onSuccess: @escaping ()->()) {
        
        if let videoUrl = videoUrl {
            // videoデータをStorageに保存
            uploadVideoToFirebaseStorage(videoUrl, onSuccess: { (videoUrl) in
                //videoのサムネールをStorageに保存
                uploadImageToFirebaseStorage(data: data, onSuccess: { (thumbnailImageUrl) in
                    //データベースにpostを保存
                    self.sendDataToDataBase(photoUrl: thumbnailImageUrl, videoUrl: videoUrl, ratio: ratio, caption: caption, onSucess: onSuccess)
                })
            })
            
        } else {
            uploadImageToFirebaseStorage(data: data) { (imageUrl) in
                
                //データベースにpostを保存
                self.sendDataToDataBase(photoUrl: imageUrl, ratio: ratio, caption: caption, onSucess: onSuccess)
            }
        }
        
    }
    
    static private func uploadVideoToFirebaseStorage(_ fileUrl: URL, onSuccess: @escaping (_ videoUrl: String)->()) {
        let videoId = NSUUID().uuidString
        let storageRef = FIRStorage.storage().reference().child(POSTS).child(videoId)
        
        storageRef.putFile(fileUrl, metadata: nil) { (metaData, error) in
            if error != nil {
                ProgressHUD.showError(error!.localizedDescription)
                return
            }
            if let videoUrl = metaData?.downloadURL()?.absoluteString {
                onSuccess(videoUrl)
            }
        }
        
    }
    
    static private func uploadImageToFirebaseStorage(data: Data, onSuccess: @escaping (_ imageUrl: String)->()) {
        
        let photoId = NSUUID().uuidString
        let storageRef = FIRStorage.storage().reference().child(POSTS).child(photoId)
        storageRef.put(data, metadata: nil) { (metaData, error) in
            if error != nil {
                ProgressHUD.showError(error!.localizedDescription)
                return
            }
            if let photoUrl = metaData?.downloadURL()?.absoluteString {
                onSuccess(photoUrl)
            }
        }
        
    }
    
    static private func sendDataToDataBase(photoUrl: String, videoUrl: String? = nil, ratio: CGFloat, caption: String, onSucess: @escaping ()->()) {
        
        let newPostId = Api.Post.REF_POSTS.childByAutoId().key
        let newPostRef = Api.Post.REF_POSTS.child(newPostId)
        
        guard let currentUserId = Api.User.CURRENT_USER?.uid else { return }
        
        var dict: [String: Any] = ["userId": currentUserId,
                                   "photoUrl": photoUrl,
                                   "likeCount": 0,
                                   "captionText": caption,
                                   "ratio": ratio]
        
        //videoの場合にはdictにvideoUrlも追加する
        if let videoUrl = videoUrl {
            dict["videoUrl"] = videoUrl
        }
        
        
        newPostRef.setValue(dict) { (error, ref) in
            
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


















