//
//  HomeTableViewCell.swift
//  MyInstaStory
//
//  Created by park kyung suk on 2017/08/07.
//  Copyright © 2017年 park kyung suk. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class HomeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likeImageView: UIImageView!
    @IBOutlet weak var commentImageView: UIImageView!
    @IBOutlet weak var shareImageView: UIImageView!
    @IBOutlet weak var likeCountBtn: UIButton!
    @IBOutlet weak var captionLabel: UILabel!
    
    var homeVC: HomeViewController?
    
    var post: Post? {
        didSet {
            updateView()
        }
    }
    
    var user: User? {
        didSet {
            setupUserInfo()
        }
    }
    
    private func updateView() {
        
        //profileImageView.image = UIImage(named: "sample.jpg")
        if let postImageUrlString = post?.photoUrl, let postImageUrl = URL(string: postImageUrlString) {
            postImageView.sd_setImage(with: postImageUrl)
            captionLabel.text = post?.caption
            //PostのLikeを反映
            reflectLikes()
        }
    }
    
    private func reflectLikes() {
        guard let currentUserId = FIRAuth.auth()?.currentUser?.uid, let postId = post?.id else { return }
        //Set like observe
        //このセルが表示される際、カレントユーザーがこのPostにLikeした記録の値が取得できた場合にはLike,でない場合にはNoLike
        Api.User.REF_USERS.child(currentUserId).child("likes").child(postId).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let _ = snapshot.value as? NSNull {
                self.likeImageView.image = UIImage(named: "like.png")
            } else {
                self.likeImageView.image = UIImage(named: "likeSelected.png")
            }
        })
        
    }
    
    private func setupUserInfo() {
        
        nameLabel.text = user?.username
        if let profileImageUrlString = user?.profileImageUrl, let profileImageUrl = URL(string: profileImageUrlString) {
            profileImageView.sd_setImage(with: profileImageUrl, placeholderImage: UIImage(named: "placeholderImg.png"))
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameLabel.text = ""
        captionLabel.text = ""
        commentImageView.isUserInteractionEnabled = true
        commentImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(commentImageViewTapped)))
        likeImageView.isUserInteractionEnabled = true
        likeImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(likeImageViewTapped)))
    }
    
    func commentImageViewTapped() {
        
        if let postId =  post?.id {
            
            homeVC?.performSegue(withIdentifier: "CommentViewSegue", sender: postId)
            
        }
    }
    func likeImageViewTapped() {
    
        guard let currentUserId = FIRAuth.auth()?.currentUser?.uid, let postId = post?.id else { return }
        
        //currentUserのlikeがある場合にはlikeを解除、likeがnullの場合にはlikeSelected
        Api.User.REF_USERS.child(currentUserId).child("likes").child(postId).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let _ = snapshot.value as? NSNull {
                Api.User.REF_USERS.child(currentUserId).child("likes").child(postId).setValue(true)
                self.likeImageView.image = UIImage(named: "likeSelected")
                
            } else {
                Api.User.REF_USERS.child(currentUserId).child("likes").child(postId).removeValue()
                self.likeImageView.image = UIImage(named: "like")
            }
        })
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        //セルがreuseされる際、表示中のデータが誤って一瞬表示する不具合を防ぐためここでdefaultデータを設定
        profileImageView.image = UIImage(named: "placeholderImg.png")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
