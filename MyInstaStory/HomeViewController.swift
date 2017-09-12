//
//  HomeViewController.swift
//  MyInsta
//
//  Created by park kyung suk on 2017/08/04.
//  Copyright © 2017年 park kyung suk. All rights reserved.
//

import UIKit
import SDWebImage

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var posts = [Post]()
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 513
        //Cellの高さを自動に調整してくれる
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.dataSource = self
        loadPosts()
    }
    
    func loadPosts() {
        
        guard let currentUser = Api.User.CURRENT_USER else { return }
        
        Api.Feed.ovserveFeed(withId: currentUser.uid) { (post) in
            guard let postUserId = post.userId else { return }
            self.fetchUser(userId: postUserId, completion: {
                self.posts.append(post)
                self.tableView.reloadData()
            })
        }
        
        Api.Feed.observeFeedRemoved(withId: currentUser.uid) { (post) in
            
            self.posts = self.posts.filter { $0.id != post.id }
            self.users = self.users.filter { $0.id != post.userId }
            self.tableView.reloadData()
        }
    }
    
    private func fetchUser(userId: String, completion: @escaping ()->()) {
        //UserInfoをFetchしてusers配列にセット
        
        Api.User.observeUser(withId: userId) { (user) in
            self.users.append(user)
            completion()
        }
    }
    
    
    @IBAction func dummyBtn(_ sender: Any) {
        performSegue(withIdentifier: "CommentSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CommentViewSegue" {
            let commentVC = segue.destination as! CommentViewController
            commentVC.postId = sender as! String
        }
        
        if segue.identifier == "Home_ProfileSegue" {
            let profileVC = segue.destination as! ProfileUserViewController
            profileVC.userId = sender as! String
        }

    }
}

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! HomeTableViewCell
        cell.post = posts[indexPath.row]
        cell.user = users[indexPath.row]
        cell.delegate = self
        return cell
    }
}

extension HomeViewController: HomeTableViewCellDelegate {
    
    func goToCommentVC(withId postId: String) {
        
      self.performSegue(withIdentifier: "CommentViewSegue", sender: postId)
    }
    
    func goToProfileUserVC(withId userId: String) {
        
        self.performSegue(withIdentifier: "Home_ProfileSegue", sender: userId)
    }
}






