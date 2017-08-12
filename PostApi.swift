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
    
}
