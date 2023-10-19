//
//  HelperService.swift
//  MyInstaStory
//
//  Created by park kyung suk on 2017/08/13.
//  Copyright © 2017年 park kyung suk. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage
import ProgressHUD
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
        let storageRef = Storage.storage().reference().child(POSTS).child(videoId)
        
        storageRef.putFile(from: fileUrl, metadata: nil) { (metaData, error) in
            if error != nil {
                ProgressHUD.error(error)
                return
            }
            storageRef.downloadURL { url, _ in
                if let videoUrl = url?.absoluteString {
                    onSuccess(videoUrl)
                }
            }
        }
    }
    
    static private func uploadImageToFirebaseStorage(data: Data, onSuccess: @escaping (_ imageUrl: String)->()) {
        
        let photoId = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child(POSTS).child(photoId)
        storageRef.putData(data) { _ in
            
            storageRef.downloadURL { url, _ in
                if let photoUrl = url?.absoluteString {
                    onSuccess(photoUrl)
                }
            }
        }
    }
    
    static private func sendDataToDataBase(photoUrl: String, videoUrl: String? = nil, ratio: CGFloat, caption: String, onSucess: @escaping ()->()) {
        
        let newPostId = Api.Post.REF_POSTS.childByAutoId().key
        let newPostRef = Api.Post.REF_POSTS.child(newPostId!)
        
        guard let currentUserId = Api.User.CURRENT_USER?.uid else { return }
        
        let timestamp = Int(Date().timeIntervalSince1970)
        
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
                ProgressHUD.error(error)
                return
            }
            
            //feed内にも格納
            Api.Feed.REF_FEED.child(Api.User.CURRENT_USER!.uid).child(newPostId!).setValue(true)
            Api.Follow.REF_FOLLOWERS.child(Api.User.CURRENT_USER!.uid).observeSingleEvent(of: .value, with: { snapshot in
                guard let arrayShapshot = snapshot.children.allObjects as? [DataSnapshot] else { return }
                
                arrayShapshot.forEach { child in
                    Api.Feed.REF_FEED.child(child.key).updateChildValues(["\(newPostId!)": true])
                    let newNotificationId = Api.Notification.REF_NOTIFICATION.child(child.key).childByAutoId().key
                    let newNotificationRef = Api.Notification.REF_NOTIFICATION.child(child.key).child(newNotificationId!)
                    newNotificationRef.setValue(["from": Api.User.CURRENT_USER!.uid,
                                                 "type": "feed",
                                                 "objectId": newPostId!,
                                                 "timestamp": timestamp])
                    
                }
            })
            //send postしたrefをmypostsにもupdateする（profileVCにてpost一覧を表示するため）
            let myPostRef = Api.MyPosts.REF_MYPOSTS.child(currentUserId).child(newPostId!)
            myPostRef.setValue(true, withCompletionBlock: { (error, ref) in
                
                if error != nil {
                    ProgressHUD.error(error!.localizedDescription)
                    return
                }
            })
            ProgressHUD.succeed("Success")
            onSucess()
        }
    }
}


















