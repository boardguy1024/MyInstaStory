//
//  SignupViewController.swift
//  MyInsta
//
//  Created by park kyung suk on 2017/08/04.
//  Copyright © 2017年 park kyung suk. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

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
    
    @IBAction func signUpBtnTapped(_ sender: UIButton) {
        
        FIRAuth.auth()?.createUser(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
            
            if error != nil {
                print("Failed create user to firebase : \(error!)")
                return
            }
            
            if let uid = user?.uid {
                let ref = FIRDatabase.database().reference()
                let userRef = ref.child("users")
                let newUserRef = userRef.child(uid)
                newUserRef.setValue(["username": self.usernameTextField.text!,
                                     "email": self.emailTextField.text!])
            }
        })
    }
    
}
