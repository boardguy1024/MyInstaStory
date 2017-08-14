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
        
        //userがcurrentUserとfollower関係によりボタンのステータスやtargetを設定
        if user!.isFollowing! {
            configureUnFollowButton()
        } else {
            configureFollowButton()
        }
    }
    
    func configureFollowButton() {
        followBtn.layer.borderWidth = 1
        followBtn.layer.borderColor = UIColor(red: 226/255, green: 228/255, blue: 232/255, alpha: 1).cgColor
        followBtn.layer.cornerRadius = 5
        followBtn.clipsToBounds = true
        followBtn.setTitleColor(.white, for: .normal)
        followBtn.backgroundColor = UIColor(red: 69/255, green: 142/255, blue: 255/255, alpha: 1)
        followBtn.setTitle("follow", for: .normal)
        followBtn.addTarget(self, action: #selector(followAction), for: .touchUpInside)
    }
    func configureUnFollowButton() {
        followBtn.layer.borderWidth = 1
        followBtn.layer.borderColor = UIColor(red: 226/255, green: 228/255, blue: 232/255, alpha: 1).cgColor
        followBtn.layer.cornerRadius = 5
        followBtn.clipsToBounds = true
        followBtn.setTitleColor(.black, for: .normal)
        followBtn.backgroundColor = .clear
        followBtn.setTitle("following", for: .normal)
        followBtn.addTarget(self, action: #selector(unfollowAction), for: .touchUpInside)
    }
    func followAction() {
        Api.Follow.followAction(withUserId: user!.id!)
        configureUnFollowButton()
        //followしたので該当userのisFollowingにもtrueに設定（reuse時にはこのuser.isFollowの参照をみるため）
        user?.isFollowing = true
    }
    func unfollowAction() {
        Api.Follow.unfollowAction(withUserId: user!.id!)
        configureFollowButton()
        //unfollowをしたので該当userのisFollowingにもfalseに設定（reuse時にはこのuser.isFollowをみるため）
        user?.isFollowing = false
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
