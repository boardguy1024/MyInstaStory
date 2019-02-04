//
//  ActivityViewController.swift
//  MyInsta
//
//  Created by park kyung suk on 2019/02/04.
//  Copyright © 2017年 park kyung suk. All rights reserved.
//

import UIKit

class ActivityViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    
    let cellId: String = "ActivityTableViewCell"
    var notifications = [Notification]()
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadNotifications()
    }
    
    func loadNotifications() {
        guard let currentUser = Api.User.CURRENT_USER else { return }
        Api.Notification.observeNotification(withId: currentUser.uid, completion: { notification in
            guard let uid = notification.from else { return }
            
            self.fetchUser(uid: uid, completion: {
                self.notifications.insert(notification, at: 0)
                self.tableView.reloadData()
            })
        })
    }
    
    func fetchUser(uid: String, completion: @escaping () -> Void) {
        Api.User.observeUser(withId: uid, completion: { user in
            self.users.insert(user, at: 0)
            completion()
        })
    }
}

extension ActivityViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellId, for: indexPath) as! ActivityTableViewCell
        
        let notification = notifications[indexPath.row]
        let user = users[indexPath.row]
        
        cell.notification = notification
        
        return cell
    }
}
