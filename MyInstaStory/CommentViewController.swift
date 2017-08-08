//
//  CommentViewController.swift
//  MyInstaStory
//
//  Created by park kyung suk on 2017/08/08.
//  Copyright © 2017年 park kyung suk. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class CommentViewController: UIViewController {
    
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var sendBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sendBtn.isEnabled = false
        handleTextField()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    private func handleTextField() {
        commentTextField.addTarget(self, action: #selector(textFieldDidChanged), for: .editingChanged)
    }
    
    func textFieldDidChanged() {
        if let comment = commentTextField.text, !comment.isEmpty {
            sendBtn.setTitleColor(.black, for: .normal)
            sendBtn.isEnabled = true
        } else {
            sendBtn.setTitleColor(.gray, for: .normal)
            sendBtn.isEnabled = false
        }
    }
    
    @IBAction func sendBtnTapped(_ sender: Any) {
        
        let commentRef = FIRDatabase.database().reference().child(COMMNETS)
        let newCommentId = commentRef.childByAutoId().key
        let newCommentRef = commentRef.child(newCommentId)
        
        guard let currentUserId = FIRAuth.auth()?.currentUser?.uid else { return }
        
        newCommentRef.setValue(["userId": currentUserId,
                                "comment": commentTextField.text!]) { (error, ref) in
                                    
                                    if error != nil {
                                        ProgressHUD.showError(error!.localizedDescription)
                                        return
                                    }
                                    self.commentTextField.text = ""
                                    self.textFieldDidChanged()
                                    
        }
    }
}
