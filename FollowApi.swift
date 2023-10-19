//
//  FollowApi.swift
//  MyInstaStory
//
//  Created by park kyung suk on 2017/08/14.
//  Copyright © 2017年 park kyung suk. All rights reserved.
//

import Foundation
import FirebaseDatabase

class FollowApi {
    
    var REF_FOLLOWERS = Database.database().reference().child("followers")
    var REF_FOLLOWING = Database.database().reference().child("following")
    
    func followAction(withUserId id: String) {
        
        //currentUserが相手をfollowing時、myPosts内の相手のpostたちを取得してfeedノードに格納する
        Api.MyPosts.REF_MYPOSTS.child(id).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dic = snapshot.value as? [String: Any] {
                
                for key in dic.keys {
                    
                    Database.database().reference().child("feed").child(Api.User.CURRENT_USER!.uid).child(key).setValue(true)
                }
            }
        })
        
        guard let currentUserId = Api.User.CURRENT_USER?.uid else { return }
        REF_FOLLOWING.child(currentUserId).child(id).setValue(true)
        REF_FOLLOWERS.child(id).child(currentUserId).setValue(true)
    }
    
    func unfollowAction(withUserId id: String) {
        
        //feedノードに格納されている相手のpostIdを削除する
        Api.MyPosts.REF_MYPOSTS.child(id).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dic = snapshot.value as? [String: Any] {
                
                for key in dic.keys {
                    
                    Api.Feed.REF_FEED.child(Api.User.CURRENT_USER!.uid).child(key).removeValue()
                }
            }
        })

        guard let currentUserId = Api.User.CURRENT_USER?.uid else { return }
        REF_FOLLOWING.child(currentUserId).child(id).setValue(NSNull())
        REF_FOLLOWERS.child(id).child(currentUserId).setValue(NSNull())
    }
    
    func isFollowing(userId: String, completion: @escaping (Bool)->()) {
        REF_FOLLOWERS.child(userId).child(Api.User.CURRENT_USER!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let _ = snapshot.value as? NSNull {
                completion(false)
            } else {
                completion(true)
            }
        })
    }
    
    func fetchCountFollowing(userId: String, completion: @escaping (Int)->()) {
        REF_FOLLOWING.child(userId).observe(.value, with: { (snapshot) in
            completion(Int(snapshot.childrenCount))
        })
    }
    
    func fetchCountFollower(userId: String, completion: @escaping (Int)->()) {
        REF_FOLLOWERS.child(userId).observe(.value, with: { (snapshot) in
            completion(Int(snapshot.childrenCount))
        })
    }

}






