//
//  SearchViewController.swift
//  MyInstaStory
//
//  Created by park kyung suk on 2017/08/16.
//  Copyright © 2017年 park kyung suk. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    let searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.searchBarStyle = .minimal
        sb.placeholder = "Search"
        return sb
    }()
    
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        
        searchBar.frame.size.width = view.frame.size.width - 60
        let searchItem = UIBarButtonItem(customView: searchBar)
        self.navigationItem.rightBarButtonItem = searchItem
        
        //最初表示時、全てのユーザーを表示
        doSearchUser()
    }
    
    func doSearchUser() {
        
        self.users.removeAll()
        self.tableView.reloadData()
        
        if let searchText = searchBar.text?.lowercased() {
            Api.User.queryUsers(withText: searchText, completion: { (user) in
                self.isFollowing(userId: user.id!, completion: { (result) in
                    user.isFollowing = result
                    self.users.append(user)
                    self.tableView.reloadData()
                })
            })
        }
    }
    
    func isFollowing(userId: String, completion: @escaping (Bool)->()) {
        Api.Follow.isFollowing(userId: userId, completion: completion)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "Search_ProfileSegue" {
            let profileVC = segue.destination as! ProfileUserViewController
            profileVC.userId = sender as! String
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        doSearchUser()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        doSearchUser()
    }
}

extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PeopleTableViewCell", for: indexPath) as! PeopleTableViewCell
        cell.user = users[indexPath.row]
        cell.delegate = self
        return cell
    }
}

extension SearchViewController: PeopleTableViewCellDelegate {
    
    func goToProfileUserVC(withId userId: String) {
        
        self.performSegue(withIdentifier: "Search_ProfileSegue", sender: userId)
    }
}



