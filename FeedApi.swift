//
//  FeedApi.swift
//  MyInstaStory
//
//  Created by park kyung suk on 2017/08/16.
//  Copyright © 2017年 park kyung suk. All rights reserved.
//

import Foundation
import FirebaseDatabase

class FeedApi {
    
    var REF_FEED = FIRDatabase.database().reference().child("feed")
    
    func ovserveFeed(withId id: String, completion: @escaping (Post)->()) {
        REF_FEED.child(id).observe(.childAdded, with: { (snapshot) in
            
            let key = snapshot.key
            //Post Child内のkeyに該当するpostを取得しコールバッククロージャにpostモデルを渡す
            Api.Post.observePost(postId: key, completion: { (post) in
                completion(post)
            })
        })
    }
    
    func observeFeedRemoved(withId id: String, completion: @escaping (Post)->()) {
        REF_FEED.child(id).observe(.childRemoved, with: { (snapshot) in
            
           Api.Post.observePost(postId: snapshot.key, completion: { (post) in
            completion(post)
           })
        })
        
    }
}
