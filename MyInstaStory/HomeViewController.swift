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
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        
        loadPosts()
    }
    
    func loadPosts() {
        //PostsDBにAddEventが生じた場合、呼び出される。
        FIRDatabase.database().reference().child(POSTS).observe(.value) { (snapshot) in
            print(snapshot.value)
        }
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
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = UITableViewCell()
        return cell
    }
}
