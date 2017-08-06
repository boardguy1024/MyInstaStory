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
        tableView.dataSource = self
        
        loadPosts()
    }
    
    func loadPosts() {
        //PostsDBにAddEventが生じた場合、呼び出される。
        FIRDatabase.database().reference().child(POSTS).observe(.childAdded, with: { (snapshot) in
            
            if let dic = snapshot.value as? [String: Any] {
                guard let caption = dic["captionText"] as? String, let photoUrl = dic["photoUrl"] as? String else { return }
                let post = Post(captionText: caption, photoUrl: photoUrl)
                self.posts.append(post)
                
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
        
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        cell.textLabel?.text = posts[indexPath.row].caption
        return cell
    }
}
