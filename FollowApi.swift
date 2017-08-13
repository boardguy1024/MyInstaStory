//
//  FollowApi.swift
//  MyInstaStory
//
//  Created by park kyung suk on 2017/08/14.
//  Copyright © 2017年 park kyung suk. All rights reserved.
//

import Foundation
import FirebaseDatabase

class FollowApi {
    
    var REF_FOLLOWERS = FIRDatabase.database().reference().child("followers")
    var REF_FOLLOWING = FIRDatabase.database().reference().child("following")
}
