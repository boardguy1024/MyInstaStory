//
//  CameraViewController.swift
//  MyInsta
//
//  Created by park kyung suk on 2017/08/04.
//  Copyright © 2017年 park kyung suk. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth


class CameraViewController: UIViewController {
    
    @IBOutlet weak var removeBtn: UIButton!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var captionTextView: UITextView!
    @IBOutlet weak var shareBtn: UIButton!
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoImageView.isUserInteractionEnabled = true
        photoImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectPhoto)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handlePost()
    }
    
    func handlePost() {
        if selectedImage != nil {
            shareBtn.backgroundColor = .black
            shareBtn.isEnabled = true
            removeBtn.isEnabled = true
        } else {
            shareBtn.backgroundColor = .darkGray
            shareBtn.isEnabled = false
            removeBtn.isEnabled = false
        }
        
    }
    @IBAction func removeBtnTapped(_ sender: Any) {
        postClean()
        handlePost()
    }
    
    func postClean() {
        
        self.captionTextView.text = ""
        self.photoImageView.image = UIImage(named: "Placeholder-image")
        //Shareボタンを非活性化するため
        self.selectedImage = nil
    }
    
    @IBAction func shareBtnTapped(_ sender: Any) {
        
        //   guard let uid = user?.uid else { return }
        ProgressHUD.show("Waiting..", interaction: false)
        
        if let photoImage = self.photoImageView.image, let imageData = UIImageJPEGRepresentation(photoImage, 0.1) {
            
            //postImageのuidを自動生成
            let uid = NSUUID().uuidString
            //ストレージRef
            let storageRef = FIRStorage.storage().reference().child(POSTS).child(uid)
            //ストレージにprofileImageを保存
            storageRef.put(imageData, metadata: nil, completion: { (metaData, error) in
                if error != nil {
                    ProgressHUD.showError(error!.localizedDescription)
                    return
                }
                let photoUrl = metaData?.downloadURL()?.absoluteString
                
                //データベースにpostを保存
                self.sendDataToDataBase(photoUrl: photoUrl!)
            })
        }
    }
    func sendDataToDataBase(photoUrl: String) {
        let ref = FIRDatabase.database().reference()
        let postsRef = ref.child("posts")
        let newPostsId = postsRef.childByAutoId().key
        let newPostsRef = postsRef.child(newPostsId)
        guard let currentUserId = FIRAuth.auth()?.currentUser?.uid else { return }
        newPostsRef.setValue(["userId": currentUserId,
                              "photoUrl":photoUrl,
                              "captionText": captionTextView.text!]) { (error, ref) in
                                
                                if error != nil {
                                    ProgressHUD.showError(error!.localizedDescription)
                                    return
                                }
                                ProgressHUD.showSuccess("Success")
                                self.postClean()
                                //DBに保存成功した場合、HomeTabBarVCに遷移する
                                self.tabBarController?.selectedIndex = 0
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

extension CameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK:- Gesture Methods
    func handleSelectPhoto() {
        //Photo Librayを表示する
        let imagePickerCotroller = UIImagePickerController()
        imagePickerCotroller.delegate = self
        imagePickerCotroller.allowsEditing = true
        present(imagePickerCotroller, animated: true, completion: nil)
    }
    
    //MARK:- UIImagePicker Delegate Mathods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info["UIImagePickerControllerEditedImage"] as? UIImage {
            photoImageView.image = image
            selectedImage = image
        }
        dismiss(animated: true, completion: nil)
    }
}


