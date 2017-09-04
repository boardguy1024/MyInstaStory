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
        
            guard let imageUrlString = user.profileImageUrl,
                  let imageUrl = URL(string: imageUrlString),
                  let userName = user.username,
                let email = user.email else { return }
            
            self.profileImageView.sd_setImage(with: imageUrl)
            self.nameTextField.text = userName
            self.emailTextField.text = email
        }
    }
}
