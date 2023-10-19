//
//  HeaderProfileCollectionReusableView.swift
//  MyInstaStory
//
//  Created by park kyung suk on 2017/08/11.
//  Copyright © 2017年 park kyung suk. All rights reserved.
//

import UIKit
import Kingfisher

protocol HeaderProfileCollectionReusableViewDelegate {
    func updateFollowButton(forUser user: User)
}

protocol HeaderProfileCollectionReusableViewDelegateToSwitchSettingVC {
    func goToSettingVC()
}

class HeaderProfileCollectionReusableView: UICollectionReusableView {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var myPostsCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followerCounterLabel: UILabel!
    @IBOutlet weak var followBtn: UIButton!

    var delegate: HeaderProfileCollectionReusableViewDelegate?
    var delegateForSwitchSettingVC: HeaderProfileCollectionReusableViewDelegateToSwitchSettingVC?
    
    var user: User? {
        didSet {
            if user != nil {
                updateView()
            }
        }
    }
    
    func updateView() {
        
        if let imageUrlString = user?.profileImageUrl, let profileImageUrl = URL(string: imageUrlString) {
            self.profileImageView.kf.setImage(with: profileImageUrl, placeholder: UIImage(named: "placeholderImg.png"))
            self.nameLabel.text = user?.username
        }
        
        Api.MyPosts.fetchCountMyPosts(userId: user!.id!) { (postCount) in
            self.myPostsCountLabel.text = "\(postCount)"
        }
        
        Api.Follow.fetchCountFollowing(userId: user!.id!) { (followingCount) in
            self.followingCountLabel.text = "\(followingCount)"
        }
        
        Api.Follow.fetchCountFollower(userId: user!.id!) { (followerCount) in
            self.followerCounterLabel.text = "\(followerCount)"
        }

        //CurrentUserの場合
        if user?.id == Api.User.CURRENT_USER?.uid {
            followBtn.setTitle("Edit Profile", for: .normal)
            followBtn.addTarget(self, action: #selector(goToSettingVC), for: .touchUpInside)
        } else {
            //ここのuserがcurrentUserでない場合には
            //currentUserとfollowしているかどうかをチェックしボタンにそのステータスを反映
            //そのボタンの機能も追加
            updateStateFollowBtn()
        }
    }
    
    //Edit Profileボタンがタップした際SettingVCへの遷移をprofileVCにやってもらうようにする
    @objc func goToSettingVC() {
        delegateForSwitchSettingVC?.goToSettingVC()
    }
    
    func updateStateFollowBtn() {
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
    @objc func followAction() {
        Api.Follow.followAction(withUserId: user!.id!)
        configureUnFollowButton()
        //followしたので該当userのisFollowingにもtrueに設定（reuse時にはこのuser.isFollowの参照をみるため）
        user?.isFollowing = true
        delegate?.updateFollowButton(forUser: user!)
    }
    @objc func unfollowAction() {
        Api.Follow.unfollowAction(withUserId: user!.id!)
        configureFollowButton()
        //unfollowをしたので該当userのisFollowingにもfalseに設定（reuse時にはこのuser.isFollowをみるため）
        user?.isFollowing = false
        delegate?.updateFollowButton(forUser: user!)
    }
    
}















