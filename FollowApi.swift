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
    
    var REF_FOLLOWERS = FIRDatabase.database().reference().child("followers")
    var REF_FOLLOWING = FIRDatabase.database().reference().child("following")
    
    func followAction(withUserId id: String) {
        guard let currentUserId = Api.User.CURRENT_USER?.uid else { return }
        REF_FOLLOWING.child(currentUserId).child(id).setValue(true)
        REF_FOLLOWERS.child(id).child(currentUserId).setValue(true)
    }
    
    func unfollowAction(withUserId id: String) {
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
}
