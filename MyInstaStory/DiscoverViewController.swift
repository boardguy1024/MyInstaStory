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
        
        loadTopPost()
    }
        
    func loadTopPost() {
        ProgressHUD.show("Loading...", interaction: false)
        self.posts.removeAll()
        self.collectionView.reloadData()
        Api.Post.observeTopPosts { (post) in
            self.posts.append(post)
            self.collectionView.reloadData()
            ProgressHUD.dismiss()
        }
    }
    
    @IBAction func refreshButtonTapped(_ sender: Any) {
        loadTopPost()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Discover_DetailSegue" {
            if let detailVC = segue.destination as? DetailViewController, let postId = sender as? String {
                detailVC.postId = postId
            }
        }
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
        cell.delegate = self
        
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


extension DiscoverViewController: DiscoverCollectionViewCellDelegate {
    func goToDetailVC(postId: String) {
        
        performSegue(withIdentifier: "Discover_DetailSegue", sender: postId)
    }
}



