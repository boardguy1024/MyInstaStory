//
//  PeopleViewController.swift
//  MyInstaStory
//
//  Created by park kyung suk on 2017/08/13.
//  Copyright © 2017年 park kyung suk. All rights reserved.
//

import UIKit

class PeopleViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        loadUser()
    }
    
    func loadUser() {
        Api.User.observeUsers { (user) in
            
            self.isFollowing(userId: user.id!, completion: { (result) in
                user.isFollowing = result
                self.users.append(user)
                self.tableView.reloadData()
            })
        }
    }
    
    func isFollowing(userId: String, completion: @escaping (Bool)->()) {
        Api.Follow.isFollowing(userId: userId, completion: completion)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ProfileSegue" {
            let profileVC = segue.destination as! ProfileUserViewController
            profileVC.userId = sender as! String
        }
    }
}

extension PeopleViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PeopleTableViewCell", for: indexPath) as! PeopleTableViewCell
        cell.peopleVC = self
        cell.user = users[indexPath.row]
        
        return cell
    }
    
}






