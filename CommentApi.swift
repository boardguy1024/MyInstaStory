//
//  CommentApi.swift
//  MyInstaStory
//
//  Created by park kyung suk on 2017/08/10.
//  Copyright © 2017年 park kyung suk. All rights reserved.
//

import Foundation
import FirebaseDatabase

class CommentApi {
   
    var REF_COMMENTS = FIRDatabase.database().reference().child("comments")
    
    func observeComments(withId: String, completion: @escaping (Comment)->()) {
        
        REF_COMMENTS.child(withId).observeSingleEvent(of: .value, with: { (commentSnapshot) in
           
            if let dic = commentSnapshot.value as? [String: Any] {
                let comment = Comment.tranformComment(dic: dic)
                completion(comment)
            }
        })
    }
}
