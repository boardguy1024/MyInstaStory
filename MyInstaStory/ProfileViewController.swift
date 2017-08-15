//
//  ProfileViewController.swift
//  MyInsta
//
//  Created by park kyung suk on 2017/08/04.
//  Copyright © 2017年 park kyung suk. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var user: User? {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        fetchUser()
        fetchMyPosts()
    }
    
    func fetchUser() {
        Api.User.observeCurrentUser { (currentUser) in
            self.navigationItem.title = currentUser.username
            self.user = currentUser
        }
    }
    func fetchMyPosts() {
        guard let currentUserId = Api.User.CURRENT_USER?.uid else { return }
        Api.MyPosts.REF_MYPOSTS.child(currentUserId).observe(.childAdded, with: { (snapshot) in
            
            Api.Post.observePost(postId: snapshot.key, completion: { (myPost) in
                self.posts.append(myPost)
                self.collectionView.reloadData()
            })
        })
    }
}

//MARK:- extensions

extension ProfileViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as! PhotoCollectionViewCell
        
        cell.post = posts[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let headerViewCell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "HeaderProfileCollectionReusableView", for: indexPath) as! HeaderProfileCollectionReusableView
        headerViewCell.user = self.user
        
        return headerViewCell
    }
}

extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    
    //セルの水平方向のマージンを設定
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    //セルの垂直方向のマージンを設定
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellSize = collectionView.frame.width / 3 - 1.0
        return CGSize(width: cellSize , height: cellSize)
    }
}


