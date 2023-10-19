//
//  SettingTableViewController.swift
//  MyInstaStory
//
//  Created by park kyung suk on 2017/09/04.
//  Copyright © 2017年 park kyung suk. All rights reserved.
//

import UIKit
import Kingfisher
import ProgressHUD

protocol SettingTableViewControllerDelegate {
    func updateUserInfo()
}

class SettingTableViewController: UITableViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    var delegate: SettingTableViewControllerDelegate?
    
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
                self.profileImageView.kf.setImage(with: imageUrl)
            }
        }
    }
    
    @IBAction func changePhotoBtnTapped(_ sender: Any) {
        let imagePickerCotroller = UIImagePickerController()
        imagePickerCotroller.delegate = self
        imagePickerCotroller.allowsEditing = true
        present(imagePickerCotroller, animated: true, completion: nil)
    }
    
    @IBAction func saveBtnTapped(_ sender: Any) {
        
        if let profileImage = self.profileImageView.image?.jpegData(compressionQuality: 0.1) {
            
            AuthService.updateUserInfo(username: nameTextField.text!, email: emailTextField.text!, imageData: profileImage, onSuccess: {
                ProgressHUD.progress(1)
                self.delegate?.updateUserInfo()
            }, onError: { (errorMessage) in
                ProgressHUD.error(errorMessage)
                return
            })
        }
    }
    
    @IBAction func logoutBtnTapped(_ sender: Any) {
        
        AuthService.logOut(onSuccess: {
            
            self.dismiss(animated: true, completion: nil)
        }) { (errorMessage) in
            ProgressHUD.error(errorMessage)
        }
    }
    
}

extension SettingTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK:- UIImagePicker Delegate Mathods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let seletedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            profileImageView.image = seletedImage
        }
        dismiss(animated: true, completion: nil)
    }
}

extension SettingTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}

































