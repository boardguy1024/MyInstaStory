//
//  HomeTableViewCell.swift
//  MyInstaStory
//
//  Created by park kyung suk on 2017/08/07.
//  Copyright © 2017年 park kyung suk. All rights reserved.
//

import UIKit
import AVFoundation
import ProgressHUD
import Kingfisher

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
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    
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
        
        // ratio = widthPhoto / heightPhoto    == 1.5
        // heightPhoto = widthPhoto / ratio
        if let ratio = post?.ratio {
            print("frame post Image: \(postImageView.frame)")
            heightConstraint.constant = UIScreen.main.bounds.width / ratio
            print("frame post Image: \(postImageView.frame)")
            layoutIfNeeded()
        }
        
        if let videoUrlString = post?.videoUrl, let videoUrl = URL(string: videoUrlString) {
            player = AVPlayer(url: videoUrl)
            playerLayer = AVPlayerLayer(player: player)
            playerLayer?.frame = self.postImageView.frame
            playerLayer?.frame.size.width = UIScreen.main.bounds.width
            self.contentView.layer.addSublayer(playerLayer!)
            player?.play()
        }
        
        if let postImageUrlString = post?.photoUrl, let postImageUrl = URL(string: postImageUrlString) {
            postImageView.kf.setImage(with: postImageUrl)
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
            profileImageView.kf.setImage(with: profileImageUrl, placeholder: UIImage(named: "placeholderImg.png"))
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
    
    @objc func nameLabelTapped() {
        
        if let userId = user?.id {
            
            delegate?.goToProfileUserVC(withId: userId)
        }
    }
    
    
    @objc func commentImageViewTapped() {
        
        if let postId =  post?.id {
            
            delegate?.goToCommentVC(withId: postId)
        }
    }
    
    @objc func likeImageViewTapped() {
        
        if let postId = post?.id {
            Api.Post.incrementOrdecreaseLikes(withPostId: postId , onSuccess: { (post) in
                self.updateLike(post: post)
                //cellがReuse時、
                //dbにupdateが成功した場合にController内のposts配列内にキャッシュされている該当postにもupdateする
                self.post?.isLiked = post.isLiked
                self.post?.likeCount = post.likeCount
                self.post?.likes = post.likes
                
            }, onError: { (error) in
                ProgressHUD.error(error)
            })
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        //セルがreuseされる際、表示中のデータが誤って一瞬表示する不具合を防ぐためここでdefaultデータを設定
        profileImageView.image = UIImage(named: "placeholderImg.png")
        
        playerLayer?.removeFromSuperlayer()
        player?.pause()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}











