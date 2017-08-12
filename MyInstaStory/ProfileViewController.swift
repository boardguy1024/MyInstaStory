//
//  ProfileViewController.swift
//  MyInsta
//
//  Created by park kyung suk on 2017/08/04.
//  Copyright © 2017年 park kyung suk. All rights reserved.
//

import UIKit
import FirebaseAuth

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
        fetchUser()
        fetchMyPosts()
    }
    
    func fetchUser() {
        Api.User.observeCurrentUser { (currentUser) in
            self.user = currentUser
        }
    }
    func fetchMyPosts() {
        guard let currentUserId = FIRAuth.auth()?.currentUser?.uid else { return }
        Api.myPosts.REF_MYPOSTS.child(currentUserId).observe(.childAdded, with: { (snapshot) in
            
            Api.Post.observePost(postId: snapshot.key, completion: { (myPost) in
                self.posts.append(myPost)
                self.collectionView.reloadData()
            })
        })
    }
}

extension ProfileViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let headerViewCell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "HeaderProfileCollectionReusableView", for: indexPath) as! HeaderProfileCollectionReusableView
        headerViewCell.user = self.user
        
        return headerViewCell
    }
}
