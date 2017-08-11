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
    
    var postRef: FIRDatabaseReference!
    
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
            updateLike(post: post!)
            
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
            postRef = Api.Post.REF_POSTS.child(postId)
            incrementOrdecreaseLikes(forRef: postRef)
        }
    }
    
    func incrementOrdecreaseLikes(forRef ref: FIRDatabaseReference ) {
        
        ref.runTransactionBlock({ (currentData: FIRMutableData) -> FIRTransactionResult in
            
            if var post = currentData.value as? [String : AnyObject], let uid = FIRAuth.auth()?.currentUser?.uid {
                
                //nil -> [:]
                var likes = post["likes"] as? [String : Bool] ?? [:]
                //nil -> 0
                var likeCount = post["likeCount"] as? Int ?? 0
                
                // currentUserがlikesした履歴が取得できた場合には
                // --likeCount ,自分がいいねした値(currentUserId)を削除
                if let _ = likes[uid] {
                    likeCount -= 1
                    likes.removeValue(forKey: uid)
                    //currentUserがlikeしていないならインクリメントする。
                } else {
                    likeCount += 1
                    likes[uid] = true
                }
                //postに値を反映
                post["likeCount"] = likeCount as AnyObject?
                post["likes"] = likes as AnyObject?
                
                // Set value and report transaction success
                currentData.value = post
                
                //FirDBに変更されたデータをPushBack!
                return FIRTransactionResult.success(withValue: currentData)
            }
            return FIRTransactionResult.success(withValue: currentData)
        }) { (error, committed, snapshot) in
            if let error = error {
                print(error.localizedDescription)
            }
            guard let dic = snapshot?.value as? [String: Any] else { return }
            let post = Post.tranformPost(dic: dic, key: snapshot!.key)
            self.updateLike(post: post)
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
