//
//  PeopleTableViewCell.swift
//  MyInstaStory
//
//  Created by park kyung suk on 2017/08/14.
//  Copyright © 2017年 park kyung suk. All rights reserved.
//

import UIKit

class PeopleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var followBtn: UIButton!
    
    var user: User? {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        if let imageUrlString = user?.profileImageUrl, let profileImageUrl = URL(string: imageUrlString) {
            profileImageView.sd_setImage(with: profileImageUrl, placeholderImage: UIImage(named: "placeholderImg.png"))
            nameLabel.text = user?.username
        }
        //Viewに表示した後TargetをAdd
       // followBtn.addTarget(self, action: #selector(followAction), for: .touchUpInside)
      followBtn.addTarget(self, action: #selector(unfollowAction), for: .touchUpInside)
    }
    
    func followAction() {
        Api.Follow.REF_FOLLOWING.child(Api.User.CURRENT_USER!.uid).child(user!.id!).setValue(true)
        Api.Follow.REF_FOLLOWERS.child(user!.id!).child(Api.User.CURRENT_USER!.uid).setValue(true)
    }
    
    func unfollowAction() {
        Api.Follow.REF_FOLLOWING.child(Api.User.CURRENT_USER!.uid).child(user!.id!).setValue(NSNull())
        Api.Follow.REF_FOLLOWERS.child(user!.id!).child(Api.User.CURRENT_USER!.uid).setValue(NSNull())
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameLabel.text = ""
        profileImageView.image = UIImage(named: "placeholderImg.png")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = ""
        profileImageView.image = UIImage(named: "placeholderImg.png")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
