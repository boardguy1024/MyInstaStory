//
//  post.swift
//  MyInstaStory
//
//  Created by park kyung suk on 2017/08/06.
//  Copyright © 2017年 park kyung suk. All rights reserved.
//

import Foundation
import FirebaseAuth

class Post {
    
    var userId: String?
    var caption: String?
    var photoUrl: String?
    var id: String?
    var likeCount: Int?
    var likes: [String: Any]?
    var isLiked: Bool?
}

extension Post {
    
    static func tranformPost(dic: [String: Any], key: String) -> Post {
        
        let post = Post()
        post.userId = dic["userId"] as? String
        post.caption = dic["captionText"] as? String
        post.photoUrl = dic["photoUrl"] as? String
        post.likeCount = dic["likeCount"] as? Int
        post.likes = dic["likes"] as? [String: Any]
        post.id = key
        
        //まずlikesがnilかどうかを確認後nilではない場合に
        if post.likes != nil {
            
            if let currentUserId = FIRAuth.auth()?.currentUser?.uid {
                //currentUserId、つまりログインユーザーがlikeしたかどうか確認
                post.isLiked = post.likes![currentUserId] != nil
                
            }
        }
        
        return post
    }
    
}

