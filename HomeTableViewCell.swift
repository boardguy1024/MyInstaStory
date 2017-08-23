//
//  HomeTableViewCell.swift
//  MyInstaStory
//
//  Created by park kyung suk on 2017/08/07.
//  Copyright © 2017年 park kyung suk. All rights reserved.
//

import UIKit

protocol HomeTableViewCellDelegate {
    func goToCommentVC(withId postId: String)
    func goToProfileUserVC(withId userId: String)
}

class HomeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likeImageView: UIImageView!
    @IBOutlet weak var commentImageView: UIImageView!
    @IBOutlet weak var shareImageView: UIImageView!
    @IBOutlet weak var likeCountBtn: UIButton!
    @IBOutlet weak var captionLabel: UILabel!
    
    //HomeTableViewCellのDelegate
    var delegate: HomeTableViewCellDelegate?
        
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
            self.updateLike(post: post!)
        }
    }
    
    
    private func updateLike(post: Post) {
        
        likeImageView.image = UIImage(named: post.isLiked != nil ? "likeSelected.png" : "like.png")
        
        guard let count = post.likeCount else { return }
        
        if count != 0 {
            likeCountBtn.setTitle("\(count) likes", for: .normal)
        } else {
            likeCountBtn.setTitle("Be the first like this", for: .normal)
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
        likeImageView.isUserInteractionEnabled = true
        likeImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(likeImageViewTapped)))
        nameLabel.isUserInteractionEnabled = true
        nameLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(nameLabelTapped)))
    }
    
    func nameLabelTapped() {
        
        if let userId = user?.id {
            
            delegate?.goToProfileUserVC(withId: userId)
        }
    }

    
    func commentImageViewTapped() {
        
        if let postId =  post?.id {
            
            delegate?.goToCommentVC(withId: postId)
        }
    }
    
    func likeImageViewTapped() {
        
        if let postId = post?.id {
            Api.Post.incrementOrdecreaseLikes(withPostId: postId , onSuccess: { (post) in
                self.updateLike(post: post)
                //cellがReuse時、
                //dbにupdateが成功した場合にController内のposts配列内にキャッシュされている該当postにもupdateする
                self.post?.isLiked = post.isLiked
                self.post?.likeCount = post.likeCount
                self.post?.likes = post.likes
                
            }, onError: { (error) in
                ProgressHUD.showError(error)
            })
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











