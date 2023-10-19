//
//  ProfileUserViewController.swift
//  MyInstaStory
//
//  Created by park kyung suk on 2017/08/22.
//  Copyright © 2017年 park kyung suk. All rights reserved.
//

import UIKit

class ProfileUserViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var user: User!
    var posts = [Post]()
    var userId = ""
    
    var delegate: HeaderProfileCollectionReusableViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        fetchUser()
        fetchMyPosts()
    }
    
    func fetchUser() {
     
        Api.User.observeUser(withId: userId) { (user) in
            self.isFollowing(userId: user.id!, completion: { (value) in
                self.navigationItem.title = user.username
                self.user = user
                self.user.isFollowing = value
                self.collectionView.reloadData()
            })
            
        }
    }
    
    func isFollowing(userId: String, completion: @escaping (Bool)->()) {
        Api.Follow.isFollowing(userId: userId, completion: completion)
    }
    
    func fetchMyPosts() {
        
        Api.MyPosts.fetchMyPosts(userId: userId) { (key) in
            Api.Post.observePost(postId: key, completion: { (myPost) in
                self.posts.append(myPost)
                self.collectionView.reloadData()
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ProfileUser_DetailSegue" {
            let detailVC = segue.destination as! DetailViewController
            detailVC.postId = sender as! String
        }
    }
    
}
//MARK:- extensions

extension ProfileUserViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as! PhotoCollectionViewCell
        
        cell.post = posts[indexPath.row]
        cell.delegate = self
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let headerViewCell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderProfileCollectionReusableView", for: indexPath) as! HeaderProfileCollectionReusableView
        headerViewCell.user = self.user
        headerViewCell.delegate = self.delegate
        headerViewCell.delegateForSwitchSettingVC = self
        
        return headerViewCell
    }
}

extension ProfileUserViewController: UICollectionViewDelegateFlowLayout {
    
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

extension ProfileUserViewController: HeaderProfileCollectionReusableViewDelegateToSwitchSettingVC {
    func goToSettingVC() {
        performSegue(withIdentifier: "Profile_UserSettingSegue", sender: nil)
    }
}

extension ProfileUserViewController: PhotoCollectionViewCellDelegate {
    func goToDetailVC(postId: String) {
        performSegue(withIdentifier: "ProfileUser_DetailSegue", sender: postId)
    }
}








