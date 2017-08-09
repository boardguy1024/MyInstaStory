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
        }
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
    }
    
    func commentImageViewTapped() {
        
        if let postId =  post?.id {
            
            homeVC?.performSegue(withIdentifier: "CommentViewSegue", sender: postId)
            
        }
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
