//
//  HomeTableViewCell.swift
//  MyInstaStory
//
//  Created by park kyung suk on 2017/08/07.
//  Copyright © 2017年 park kyung suk. All rights reserved.
//

import UIKit
import FirebaseDatabase

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likeImageView: UIImageView!
    @IBOutlet weak var commentImageView: UIImageView!
    @IBOutlet weak var shareImageView: UIImageView!
    @IBOutlet weak var likeCountBtn: UIButton!
    @IBOutlet weak var captionLabel: UILabel!
    
    var post: Post? {
        didSet {
            updateView()
        }
    }
    
    //cellさんの個人タスク
    private func updateView() {
        
        //profileImageView.image = UIImage(named: "sample.jpg")
        if let postImageUrlString = post?.photoUrl, let postImageUrl = URL(string: postImageUrlString) {
            postImageView.sd_setImage(with: postImageUrl)
            captionLabel.text = post?.caption
            setupUserInfo()
        }
    }
    
    private func setupUserInfo() {
        if let userId = post?.userId {
            //該当Postに対しユーザー情報を取得するため、1回だけデータを取得するobserveSingleEventを使う
            FIRDatabase.database().reference().child(USERS).child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let dic = snapshot.value as? [String: Any] {
                    
                    let user = User.fransformUser(dic: dic)
                    
                    if let profileImageUrlString = user.profileImageUrl, let profileImageUrl = URL(string: profileImageUrlString) {
                    
                        self.profileImageView.sd_setImage(with: profileImageUrl)
                        self.nameLabel.text = user.username
                    }
                }
            })
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
