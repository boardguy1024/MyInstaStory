//
//  HomeTableViewCell.swift
//  MyInstaStory
//
//  Created by park kyung suk on 2017/08/07.
//  Copyright © 2017年 park kyung suk. All rights reserved.
//

import UIKit

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
            
            //セルがreuse時、postデータはDBから取得するようにする
            Api.Post.REF_POSTS.child(post!.id!).observeSingleEvent(of: .value, with: { (snapshot) in
                guard let dic = snapshot.value as? [String: Any] else { return }
                let post = Post.tranformPost(dic: dic, key: snapshot.key)
                self.updateLike(post: post)
            })
            
            //該当postのchildChanged Observeを追加し、何らかの変更があった場合に画面に反映する
            Api.Post.REF_POSTS.child(post!.id!).observe(.childChanged, with: { (snapshot) in
                
                //LikeCountのみを取得したいので　Int型だけを取得する
                guard let count = snapshot.value as? Int else { return }
                self.likeCountBtn.setTitle("\(count) likes", for: .normal)
            })
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
    }
    
    func commentImageViewTapped() {
        
        if let postId =  post?.id {
            
            homeVC?.performSegue(withIdentifier: "CommentViewSegue", sender: postId)
        }
    }
    func likeImageViewTapped() {
        
        if let postId = post?.id {
            Api.Post.incrementOrdecreaseLikes(withPostId: postId , onSuccess: { (post) in
                self.updateLike(post: post)
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
