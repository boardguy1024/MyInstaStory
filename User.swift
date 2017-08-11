//
//  User.swift
//  MyInstaStory
//
//  Created by park kyung suk on 2017/08/07.
//  Copyright © 2017年 park kyung suk. All rights reserved.
//

import Foundation

class User {
    var email: String?
    var profileImageUrl: String?
    var username: String?
}

extension User {
    static func transformUser(dic: [String: Any]) -> User {
        
        let user = User()
        user.email = dic["email"] as? String
        user.profileImageUrl = dic["profileImageUrl"] as? String
        user.username = dic["username"] as? String
        
        return user
    }
}
