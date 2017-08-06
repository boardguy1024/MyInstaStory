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


class CameraViewController: UIViewController {
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var captionTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoImageView.isUserInteractionEnabled = true
        photoImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectPhoto)))
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
                self.setUserInfomationToDataBase(photoUrl: photoUrl!)
            })
        }
    }
    func setUserInfomationToDataBase(photoUrl: String) {
        let ref = FIRDatabase.database().reference()
        let postsRef = ref.child("posts")
        let newPostsId = postsRef.childByAutoId().key
        let newPostsRef = postsRef.child(newPostsId)
        newPostsRef.setValue(["photoUrl":photoUrl]) { (error, ref) in
            
            if error != nil {
                ProgressHUD.showError(error!.localizedDescription)
                return
            }
            ProgressHUD.showSuccess("Success")
        }
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
        if let seletedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            photoImageView.image = seletedImage
        }
        dismiss(animated: true, completion: nil)
    }
}

