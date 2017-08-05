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
import FirebaseStorage

class SignupViewController: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signUpBtn.isEnabled = false
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        profileImageView.layer.masksToBounds = true
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleProfileTap)))
        
        //Text Field Extension (カスタムBlackStyleに変更)
        usernameTextField.setCustomBlackStyleTextField()
        emailTextField.setCustomBlackStyleTextField()
        passwordTextField.setCustomBlackStyleTextField()
        
        addObserveTextingChangedForTextField()
    }
    
    private func addObserveTextingChangedForTextField() {
        usernameTextField.addTarget(self, action: #selector(textFieldDidChanged), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(textFieldDidChanged), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChanged), for: .editingChanged)
    }
    //TextFieldがeditingするたびに呼び出される。
    func textFieldDidChanged() {
        
        guard let username = usernameTextField.text, !username.isEmpty,
            let email = emailTextField.text, !email.isEmpty,
            let password = passwordTextField.text, !password.isEmpty else {
                
                signUpBtn.setTitleColor(.lightText, for: .normal)
                signUpBtn.isEnabled = false
                return
        }
        signUpBtn.setTitleColor(.white, for: .normal)
        signUpBtn.isEnabled = true
    }
    
    
    @IBAction func signInBtnTappedForDismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signUpBtnTapped(_ sender: UIButton) {
        
        if let profileImage = self.profileImageView.image, let imageData = UIImageJPEGRepresentation(profileImage, 0.1) {
            
            AuthService.signUp(username: usernameTextField.text!,
                               email: emailTextField.text!,
                               password: passwordTextField.text!,
                               imageData: imageData, completion: {
                               self.performSegue(withIdentifier: "signToTabBarVC", sender: nil)
                                
            }, onError: { (error) in
                print(error!.localizedDescription)
            })
        }
    }
}

extension SignupViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK:- Gesture Methods
    func handleProfileTap() {
        //Photo Librayを表示する
        let imagePickerCotroller = UIImagePickerController()
        imagePickerCotroller.delegate = self
        imagePickerCotroller.allowsEditing = true
        present(imagePickerCotroller, animated: true, completion: nil)
    }
    
    //MARK:- UIImagePicker Delegate Mathods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let seletedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            profileImageView.image = seletedImage
        }
        dismiss(animated: true, completion: nil)
    }
}











