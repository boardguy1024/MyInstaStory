//
//  Api.swift
//  MyInstaStory
//
//  Created by park kyung suk on 2017/08/10.
//  Copyright © 2017年 park kyung suk. All rights reserved.
//

import Foundation

struct Api {
    
    static var Post = PostApi()
    static var User = UserApi()
    static var Comment = CommentApi()
    static var Post_Comment = PostCommentApi()
    static var MyPosts = MyPostApi()
    static var Follow = FollowApi()
}
