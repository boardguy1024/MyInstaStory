//
//  Api.swift
//  MyInstaStory
//
//  Created by park kyung suk on 2017/08/10.
//  Copyright © 2017年 park kyung suk. All rights reserved.
//

import Foundation

struct Api {
    
    static let Post = PostApi()
    static let User = UserApi()
    static let Comment = CommentApi()
    static let Post_Comment = PostCommentApi()
    static let MyPosts = MyPostApi()
    static let Follow = FollowApi()
    static let Feed = FeedApi()
    static let Notification = NotificationApi()
}
