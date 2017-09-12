//
//  DetailViewController.swift
//  MyInstaStory
//
//  Created by park kyung suk on 2017/09/11.
//  Copyright © 2017年 park kyung suk. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var postId = ""
    var post = Post()
    var user = User()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadPost()
    }
    
    func loadPost() {
        Api.Post.observePost(postId: postId) { (post) in
            
            guard let postUserId = post.userId else { return }
            self.fetchUser(userId: postUserId, completion: {
                self.post = post
                self.tableView.reloadData()
            })
        }
    }
    
    private func fetchUser(userId: String, completion: @escaping ()->()) {
        //UserInfoをFetchしてusers配列にセット
        
        Api.User.observeUser(withId: userId) { (user) in
            self.user = user
            completion()
        }
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

extension DetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! HomeTableViewCell
        
        cell.post = self.post
        cell.user = self.user
        cell.delegate = self
        return cell
   }
}

extension DetailViewController: HomeTableViewCellDelegate {
    
    func goToCommentVC(withId postId: String) {
        
        self.performSegue(withIdentifier: "CommentViewSegue", sender: postId)
    }
    
    func goToProfileUserVC(withId userId: String) {
        
        self.performSegue(withIdentifier: "Home_ProfileSegue", sender: userId)
    }
}






