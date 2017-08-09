//
//  PostCommentApi.swift
//  MyInstaStory
//
//  Created by park kyung suk on 2017/08/10.
//  Copyright © 2017年 park kyung suk. All rights reserved.
//

import Foundation
import FirebaseDatabase

class PostCommentApi {
    
    var REF_POSTCOMMENTS = FIRDatabase.database().reference().child("post-comments")
    
}
