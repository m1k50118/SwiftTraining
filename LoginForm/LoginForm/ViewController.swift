//
//  ViewController.swift
//  LoginForm
//
//  Created by 佐藤真 on 2020/11/24.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    let userEmail: String = "test@test.co.jp"
    let userPassword: String = "Password0001"
    
    @IBOutlet weak var emailForm: UITextField!
    @IBOutlet weak var passwordForm: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordForm.isSecureTextEntry = true
        loginButton.isEnabled = false
        loginButton.layer.cornerRadius = 5.0
    }
    
    @IBAction func formEditingChanged(_ sender: UITextField) {
        guard let email = emailForm.text,
              let password = passwordForm.text else {
            return
        }
        
        formValueValidate(email: email, password: password)
    }
    
    func formValueValidate(email: String, password: String) {
        loginButton.isEnabled = !(email.isEmpty || password.isEmpty)
    }
    
    @IBAction func loginTouchUpInside(_ sender: UIButton) {
        guard let email = emailForm.text,
              let password = passwordForm.text else {
            return
        }
        
        if email == userEmail && password == userPassword {
            if let secondViewController = storyboard?.instantiateViewController(identifier: "SecondView") {
                secondViewController.modalPresentationStyle = .fullScreen
                let transition = CATransition()
                transition.duration = 0.25
                transition.type = CATransitionType.push
                transition.subtype = CATransitionSubtype.fromRight
                view.window!.layer.add(transition, forKey: kCATransition)
                present(secondViewController, animated: false)
            }
        } else {
            let dialog = UIAlertController(title: "ログインエラー", message: "メールアドレスまたはパスワードが違います", preferredStyle: .alert)
            dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(dialog, animated: true, completion: nil)
        }
    }
}



