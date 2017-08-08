//
//  HomeViewController.swift
//  MyInsta
//
//  Created by park kyung suk on 2017/08/04.
//  Copyright © 2017年 park kyung suk. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func loadPosts() {
        activityIndicatorView.startAnimating()
        //PostsDBにAddEventが生じた場合、呼び出される。
        FIRDatabase.database().reference().child(POSTS).observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: Any] {
                let newPost = Post.tranformPost(dic: dictionary)
                self.fetchUser(userId: newPost.userId!, completion: {
                    //postInfoをposts配列にセット
                    self.posts.append(newPost)
                    self.activityIndicatorView.stopAnimating()
                    //print(Thread.isMainThread) <- true
                    self.tableView.reloadData()
                })
            }
        })
    }
    
    private func fetchUser(userId: String, completion: @escaping ()->()) {
        //UserInfoをFetchしてusers配列にセット
        FIRDatabase.database().reference().child(USERS).child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dic = snapshot.value as? [String: Any] {
                let user = User.fransformUser(dic: dic)
                self.users.append(user)
            }
            completion()
        })
        
        
    }
    
    @IBAction func logOutBtnTapped(_ sender: Any) {
        
        do {
            try FIRAuth.auth()?.signOut()
        } catch let error {
            print("Failed SignOut. reson is: \(error)")
            return
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func dummyBtn(_ sender: Any) {
        performSegue(withIdentifier: "CommentViewController", sender: nil)
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
        return cell
    }
}
