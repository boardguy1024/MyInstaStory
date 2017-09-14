//
//  CameraViewController.swift
//  MyInsta
//
//  Created by park kyung suk on 2017/08/04.
//  Copyright © 2017年 park kyung suk. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {
    
    @IBOutlet weak var removeBtn: UIButton!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var captionTextView: UITextView!
    @IBOutlet weak var shareBtn: UIButton!
    var selectedImage: UIImage?
    var videoUrl: URL?
    
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
            
            let ratio = photoImage.size.width / photoImage.size.height
            HelperService.uploadDataToServer(data: imageData, videoUrl: self.videoUrl, ratio: ratio, caption: captionTextView.text!, onSuccess: {
                
                self.postClean()
                //DBに保存成功した場合、HomeTabBarVCに遷移する
                self.tabBarController?.selectedIndex = 0
            })
        } else {
            ProgressHUD.showError("Image can't be empty")
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
        //imagePickerCotroller.allowsEditing = true
        imagePickerCotroller.mediaTypes = ["public.image","public.movie"]
        present(imagePickerCotroller, animated: true, completion: nil)
    }
    
    //MARK:- UIImagePicker Delegate Mathods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let movieUrl = info["UIImagePickerControllerMediaURL"] as? URL {
            if let thumbnailImage = thumbnailImageForMovieFileUrl(movieUrl) {
                self.videoUrl = movieUrl
                self.photoImageView.image = thumbnailImage
                self.selectedImage = thumbnailImage
            }
            
        }
        
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            photoImageView.image = image
            selectedImage = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    func thumbnailImageForMovieFileUrl(_ fileUrl: URL) -> UIImage? {
        
        let asset = AVAsset(url: fileUrl)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        
        do  {
            let thumbnailCGImage = try imageGenerator.copyCGImage(at: CMTimeMake(1, 10), actualTime: nil)
            return UIImage(cgImage: thumbnailCGImage)
        } catch let error {
            print(error)
        }
        
        return nil
    }
}




























