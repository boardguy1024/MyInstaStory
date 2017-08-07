//
//  post.swift
//  MyInstaStory
//
//  Created by park kyung suk on 2017/08/06.
//  Copyright © 2017年 park kyung suk. All rights reserved.
//

import Foundation

class Post {
    
    var userId: String?
    var caption: String?
    var photoUrl: String?
    var videoUrl: String?
}

extension Post {
    
   static func tranformPost(dic: [String: Any]) -> Post {
 
        let post = Post()
        post.userId = dic["userId"] as? String
        post.caption = dic["captionText"] as? String
        post.photoUrl = dic["photoUrl"] as? String
        
        return post
    }
    
}

