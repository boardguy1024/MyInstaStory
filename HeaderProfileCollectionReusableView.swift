//
//  HeaderProfileCollectionReusableView.swift
//  MyInstaStory
//
//  Created by park kyung suk on 2017/08/11.
//  Copyright © 2017年 park kyung suk. All rights reserved.
//

import UIKit

class HeaderProfileCollectionReusableView: UICollectionReusableView {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var myPostsCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followerCounterLabel: UILabel!

    var user: User? {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        
        if let imageUrlString = user?.profileImageUrl, let profileImageUrl = URL(string: imageUrlString) {
            self.profileImageView.sd_setImage(with: profileImageUrl, placeholderImage: UIImage(named: "placeholderImg.png"))
            self.nameLabel.text = user?.username
        }
    }
}


