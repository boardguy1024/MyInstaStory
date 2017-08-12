//
//  MyPostApi.swift
//  MyInstaStory
//
//  Created by park kyung suk on 2017/08/12.
//  Copyright © 2017年 park kyung suk. All rights reserved.
//

import Foundation
import FirebaseDatabase

class MyPostApi {
    
    var REF_MYPOSTS = FIRDatabase.database().reference().child("myPosts")
}
