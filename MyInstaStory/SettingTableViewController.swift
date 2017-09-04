//
//  SettingTableViewController.swift
//  MyInstaStory
//
//  Created by park kyung suk on 2017/09/04.
//  Copyright © 2017年 park kyung suk. All rights reserved.
//

import UIKit

class SettingTableViewController: UITableViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Edit Profile"
        
        fetchCurrentUser()
    }
    func fetchCurrentUser() {
    
        Api.User.observeCurrentUser { (user) in
        
            self.nameTextField.text = user.username
            self.emailTextField.text = user.email
            if let urlString = user.profileImageUrl, let imageUrl = URL(string: urlString) {
                self.profileImageView.sd_setImage(with: imageUrl)
            }
        }
    }
}
