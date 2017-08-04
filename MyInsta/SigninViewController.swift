//
//  SigninViewController.swift
//  MyInsta
//
//  Created by park kyung suk on 2017/08/04.
//  Copyright © 2017年 park kyung suk. All rights reserved.
//

import UIKit

class SigninViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        //textField Extension(TextfieldをBlackスタイルに変更)
        emailTextField.setCustomBlackStyleTextField()
        passwordTextField.setCustomBlackStyleTextField()
        
        }
    
  }
