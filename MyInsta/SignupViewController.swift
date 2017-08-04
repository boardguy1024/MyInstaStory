//
//  SignupViewController.swift
//  MyInsta
//
//  Created by park kyung suk on 2017/08/04.
//  Copyright © 2017年 park kyung suk. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        profileImageView.layer.masksToBounds = true
        
        //Text Field Extension (カスタムBlackStyleに変更)
        usernameTextField.setCustomBlackStyleTextField()
        emailTextField.setCustomBlackStyleTextField()
        passwordTextField.setCustomBlackStyleTextField()
    }
    
    @IBAction func signInBtnTappedForDismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
