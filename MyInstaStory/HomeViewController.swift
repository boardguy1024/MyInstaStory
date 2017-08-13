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
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    
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
        activityIndicatorView.startAnimating()
        Api.Post.observePosts { (newPost) in
            
            guard let postUserId = newPost.userId else { return }
            self.fetchUser(userId: postUserId, completion: {
                self.posts.append(newPost)
                self.activityIndicatorView.stopAnimating()
                self.tableView.reloadData()
            })
        }
    }
    
    private func fetchUser(userId: String, completion: @escaping ()->()) {
        //UserInfoをFetchしてusers配列にセット
        
        Api.User.observeUser(withId: userId) { (user) in
            self.users.append(user)
            completion()
        }
    }
    
    @IBAction func logOutBtnTapped(_ sender: Any) {
        
        AuthService.logOut(onSuccess: {
            
            self.dismiss(animated: true, completion: nil)
        }) { (errorMessage) in
            ProgressHUD.showError(errorMessage)
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
        cell.homeVC = self
        return cell
    }
}
