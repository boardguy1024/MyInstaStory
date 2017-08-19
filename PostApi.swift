//
//  PostApi.swift
//  MyInstaStory
//
//  Created by park kyung suk on 2017/08/09.
//  Copyright © 2017年 park kyung suk. All rights reserved.
//

import Foundation
import FirebaseDatabase

class PostApi {
    
    var REF_POSTS = FIRDatabase.database().reference().child("posts")
    
    func observePosts(completion: @escaping (Post)->()) {
        REF_POSTS.observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: Any] {
                let newPost = Post.tranformPost(dic: dictionary, key: snapshot.key)
                completion(newPost)
            }
        })
    }
    
    func observePost(postId: String, completion: @escaping (Post)->()) {
        REF_POSTS.child(postId).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: Any] {
                let myPost = Post.tranformPost(dic: dictionary, key: snapshot.key)
                completion(myPost)
            }
        })
    }
    
    //likeCountが多い順でpostが表示するようにpostをreturnする
    func observeTopPosts(completion: @escaping (Post)->()) {
        REF_POSTS.queryOrdered(byChild: "likeCount").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let arraySnapshot = (snapshot.children.allObjects as! [FIRDataSnapshot]).reversed()
            
            arraySnapshot.forEach({ (child) in
                
                if let dictionary = child.value as? [String: Any] {
                    let post = Post.tranformPost(dic: dictionary, key: snapshot.key)
                    completion(post)
                }
            })
        })
    }
    
    func incrementOrdecreaseLikes(withPostId postId: String, onSuccess: @escaping (Post)->(), onError: @escaping (_ errorMessage: String)->()) {
        
        let postRef = REF_POSTS.child(postId)
        
        postRef.runTransactionBlock({ (currentData: FIRMutableData) -> FIRTransactionResult in
            
            if var post = currentData.value as? [String : AnyObject], let uid = Api.User.CURRENT_USER?.uid {
                
                //nil -> [:]
                var likes = post["likes"] as? [String : Bool] ?? [:]
                //nil -> 0
                var likeCount = post["likeCount"] as? Int ?? 0
                
                // currentUserがlikesした履歴が取得できた場合には
                // --likeCount ,自分がいいねした値(currentUserId)を削除
                if let _ = likes[uid] {
                    likeCount -= 1
                    likes.removeValue(forKey: uid)
                    //currentUserがlikeしていないならインクリメントする。
                } else {
                    likeCount += 1
                    likes[uid] = true
                }
                //postに値を反映
                post["likeCount"] = likeCount as AnyObject?
                post["likes"] = likes as AnyObject?
                
                // Set value and report transaction success
                currentData.value = post
                
                //FirDBに変更されたデータをPushBack!
                return FIRTransactionResult.success(withValue: currentData)
            }
            return FIRTransactionResult.success(withValue: currentData)
        }) { (error, committed, snapshot) in
            if let error = error {
                
                onError(error.localizedDescription)
            }
            
            guard let dic = snapshot?.value as? [String: Any] else { return }
            let post = Post.tranformPost(dic: dic, key: snapshot!.key)
        
            onSuccess(post)
        }
    }
}
