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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        profileImageView.layer.masksToBounds = true
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleProfileTap)))
        
        //Text Field Extension (カスタムBlackStyleに変更)
        usernameTextField.setCustomBlackStyleTextField()
        emailTextField.setCustomBlackStyleTextField()
        passwordTextField.setCustomBlackStyleTextField()
    }
    
    @IBAction func signInBtnTappedForDismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signUpBtnTapped(_ sender: UIButton) {
        
        //MARK: - TODO
        //入力バリデーションを追加する予定
        FIRAuth.auth()?.createUser(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
            
            if error != nil {
                print("Failed create user to firebase : \(error!)")
                return
            }
            
            guard let uid = user?.uid else { return }
            //ストレージRef
            let storageRef = FIRStorage.storage().reference().child("profile_images").child(uid)
            if let profileImage = self.profileImageView.image, let imageData = UIImageJPEGRepresentation(profileImage, 0.1) {
                
                //ストレージにprofileImageを保存
                storageRef.put(imageData, metadata: nil, completion: { (metaData, error) in
                    
                    if error != nil {
                        print("Some Error to put strorage a profileImage :\(error!)")
                        return
                    }
                    
                    let profileImageUrl = metaData?.downloadURL()?.absoluteString
                    
                    //データベースRef
                    let ref = FIRDatabase.database().reference()
                    let userRef = ref.child("users")
                    let newUserRef = userRef.child(uid)
                    newUserRef.setValue(["username": self.usernameTextField.text!,
                                         "email": self.emailTextField.text!,
                                         "profileImageUrl": profileImageUrl!])
                })
            }
        })
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











