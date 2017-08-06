//
//  post.swift
//  MyInstaStory
//
//  Created by park kyung suk on 2017/08/06.
//  Copyright © 2017年 park kyung suk. All rights reserved.
//

import Foundation

class Post {
    
    var caption: String
    var photoUrl: String
    
    init(captionText: String, photoUrl: String) {
        self.caption = captionText
        self.photoUrl = photoUrl
    }
}
