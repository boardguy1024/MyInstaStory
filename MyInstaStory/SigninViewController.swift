//
//  SigninViewController.swift
//  MyInstaStory
//
//  Created by park kyung suk on 2017/08/04.
//  Copyright © 2017年 park kyung suk. All rights reserved.
//

import UIKit
import FirebaseAuth

class SigninViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signInBtn.isEnabled = false
        //textField Extension(TextfieldをBlackスタイルに変更)
        emailTextField.setCustomBlackStyleTextField()
        passwordTextField.setCustomBlackStyleTextField()
        addObserveTextingChangedForTextField()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if FIRAuth.auth()?.currentUser != nil {
            //自動TabBarHomeへ遷移は完全にビューが表示できてから遷移させる
            //Viewがまだpresentingする前の時点だとビューへ遷移などのタスクをさせないため
            self.performSegue(withIdentifier: "signToTabBarVC", sender: nil)
        }

    }
    private func addObserveTextingChangedForTextField() {
        emailTextField.addTarget(self, action: #selector(textFieldDidChanged), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChanged), for: .editingChanged)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    //TextFieldがeditingするたびに呼び出される。
    func textFieldDidChanged() {
        
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
                
                signInBtn.setTitleColor(.lightText, for: .normal)
                signInBtn.isEnabled = false
                return
        }
        signInBtn.setTitleColor(.white, for: .normal)
        signInBtn.isEnabled = true
    }
    @IBAction func signInBtnTapped(_ sender: UIButton) {
        view.endEditing(true)
        ProgressHUD.show("Waiting..", interaction: false)
        AuthService.signIn(email: emailTextField.text!, password: passwordTextField.text!, completion: {
            ProgressHUD.showSuccess("Success")
            self.performSegue(withIdentifier: "signToTabBarVC", sender: nil)
        }) { (error) in
            ProgressHUD.showError(error?.localizedDescription)
        }
        

    }
    
}










