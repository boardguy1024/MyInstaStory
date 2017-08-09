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
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!
    
    var comments = [Comment]()
    var users = [User]()
    
    let postId = "-Kr17bBzfUNMNCDB6-iv"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        sendBtn.isEnabled = false
        handleTextField()
        loadComments()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide , object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func keyboardWillShow(_ notification: NSNotification) {
    
        if let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue {
            
            UIView.animate(withDuration: 0.3, animations: {
                self.tableViewBottomConstraint.constant = keyboardFrame.height
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func keyboardWillHide(_ notification: NSNotification) {

        UIView.animate(withDuration: 0.3, animations: {
            self.tableViewBottomConstraint.constant = 0
            self.view.layoutIfNeeded()
        })
    }
    
    private func loadComments() {
        
        let postCommentsRef = FIRDatabase.database().reference().child(POST_COMMENTS).child(postId)
        postCommentsRef.observe(.childAdded, with: { (snapshot) in
        
            print("observe key")
            print(snapshot.key)
            
            let commentId = snapshot.key
            let commentsRef = FIRDatabase.database().reference().child(COMMNETS).child(commentId)
            commentsRef.observeSingleEvent(of: .value, with: { (commentSnapshot) in
            
                if let dic = commentSnapshot.value as? [String: Any] {
                    let comment = Comment.tranformComment(dic: dic)
                    
                    self.fetchUser(userId: comment.userId!, completion: {
                       
                        self.comments.append(comment)
                        print(Thread.isMainThread)
                        self.tableView.reloadData()
                        
                    })
                    
                   
                }
            })
        })
    }
    
    private func fetchUser(userId: String, completion: @escaping ()->()) {
        //UserInfoをFetchしてusers配列にセット
        FIRDatabase.database().reference().child(USERS).child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dic = snapshot.value as? [String: Any] {
                let user = User.fransformUser(dic: dic)
                self.users.append(user)
            }
            completion()
        })
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
                                    let postId = "-Kr17bBzfUNMNCDB6-iv"
                                    let postCommentRef = FIRDatabase.database().reference().child(POST_COMMENTS).child(postId).child(newCommentId)
                                    postCommentRef.setValue(true, withCompletionBlock: { (error, ref) in
                                        if error != nil {
                                            ProgressHUD.showError(error!.localizedDescription)
                                            return
                                        }
                                        
                                    })
                                    self.commentTextField.text = ""
                                    self.textFieldDidChanged()
                                    self.view.endEditing(true)
                                    
        }
    }
}

extension CommentViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentTableViewCell
        cell.comment = comments[indexPath.row]
        cell.user = users[indexPath.row]
        return cell
    }
}
