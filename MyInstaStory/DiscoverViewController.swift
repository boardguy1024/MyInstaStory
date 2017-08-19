//
//  DiscoverViewController.swift
//  MyInsta
//
//  Created by park kyung suk on 2017/08/04.
//  Copyright © 2017年 park kyung suk. All rights reserved.
//

import UIKit

class DiscoverViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self
        collectionView.delegate = self
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadTopPost()
    }
    
    func loadTopPost() {
        self.posts.removeAll()
        Api.Post.observeTopPosts { (post) in
            self.posts.append(post)
            self.collectionView.reloadData()
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

extension DiscoverViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DiscoverCollectionViewCell", for: indexPath) as! DiscoverCollectionViewCell
        
        cell.post = posts[indexPath.row]
        
        return cell
    }
    
   }

extension DiscoverViewController: UICollectionViewDelegateFlowLayout {
    
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
