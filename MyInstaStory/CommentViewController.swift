//
//  CommentViewController.swift
//  MyInstaStory
//
//  Created by park kyung suk on 2017/08/08.
//  Copyright © 2017年 park kyung suk. All rights reserved.
//

import UIKit

class CommentViewController: UIViewController {
    
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!
    
    var comments = [Comment]()
    var users = [User]()
    
    var postId: String!
    
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
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
        
        Api.Post_Comment.REF_POSTCOMMENTS.child(postId).observe(.childAdded, with: { (snapshot) in
            
            Api.Comment.observeComments(withId: snapshot.key, completion: { (comment) in
                self.fetchUser(userId: comment.userId!, completion: {
                    self.comments.append(comment)
                    self.tableView.reloadData()
                })
            })
        })
    }
    
    private func fetchUser(userId: String, completion: @escaping ()->()) {
        Api.User.observeUser(withId: userId) { (user) in
            self.users.append(user)
            completion()
        }
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
        
        let commentRef = Api.Comment.REF_COMMENTS
        let newCommentId = commentRef.childByAutoId().key
        let newCommentRef = commentRef.child(newCommentId)
        
        guard let currentUserId = Api.User.CURRENT_USER?.uid else { return }
        
        newCommentRef.setValue(["userId": currentUserId,
                                "comment": commentTextField.text!]) { (error, ref) in
                                    
                                    if error != nil {
                                        ProgressHUD.showError(error!.localizedDescription)
                                        return
                                    }
                                    
                                    Api.Post_Comment.REF_POSTCOMMENTS.child(self.postId).child(newCommentId).setValue(true, withCompletionBlock: { (error, ref) in
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "Comment_ProfileSegue" {
            let profileVC = segue.destination as! ProfileUserViewController
            profileVC.userId = sender as! String
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
        cell.delegate = self
        return cell
    }
}

extension CommentViewController: CommentTableViewCellDelegate {
    func goToProfileUserVC(withId userId: String) {
        
        self.performSegue(withIdentifier: "Comment_ProfileSegue", sender: userId)
    }
}

