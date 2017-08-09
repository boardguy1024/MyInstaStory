//
//  Comment.swift
//  MyInstaStory
//
//  Created by park kyung suk on 2017/08/09.
//  Copyright © 2017年 park kyung suk. All rights reserved.
//

import Foundation

class Comment {
    
    var userId: String?
    var commntText: String?
}

extension Comment {
    
    static func tranformComment(dic: [String: Any]) -> Comment {
        
        let comment = Comment()
        comment.userId = dic["userId"] as? String
        comment.commntText = dic["comment"] as? String
        return comment
    }
}
