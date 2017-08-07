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

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 513
        //Cellの高さを自動に調整してくれる
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.dataSource = self
        loadPosts()
    }
    
    func loadPosts() {
        //PostsDBにAddEventが生じた場合、呼び出される。
        FIRDatabase.database().reference().child(POSTS).observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: Any] {
                let newPost = Post.tranformPost(dic: dictionary)
                self.posts.append(newPost)
                //print(Thread.isMainThread) <- true
                self.tableView.reloadData()
            }
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
    
}

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! HomeTableViewCell
        
        cell.profileImageView.image = UIImage(named: "sample.jpg")
        cell.nameLabel.text = "tanaka miho"
        cell.postImageView.image = UIImage(named: "post.jpg")
        cell.captionLabel.text = "Some text!Some text!Some text!Some text!Some text!Some text!Some text!Some text!Some text!Some text!Some text!Some text!Some text!Some text!Some text!Some text!Some text!Some text!Some text!Some text!Some text!Some text!Some text!Some text!Some text!Some text!Some text!Some text!Some text!Some text!Some text!Some text!Some text!Some text!Some text!Some text!"
        
        return cell
    }
}
