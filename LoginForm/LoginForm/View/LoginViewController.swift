//
//  LoginViewController.swift
//  LoginForm
//
//  Created by 佐藤真 on 2021/01/08.
//

import UIKit
import CoreData

class LoginViewController: UIViewController {
    @IBOutlet weak var userIdForm: UITextField!
    @IBOutlet weak var passwordForm: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    private(set) var presenter: LoginPresenterInput!
    
    func inject(presenter: LoginPresenterInput) {
        self.presenter = presenter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        passwordForm.isSecureTextEntry = true
    }
    
    @IBAction func loginButtonTouchUpInside(_ sender: UIButton) {
        guard let userId = userIdForm.text else { return }
        guard let password = passwordForm.text else { return }
        
        if !presenter.didTapLoginButton(userId: userId, password: password) {
            print("success")
        } else {
            print("faild")
        }
    }
}

extension LoginViewController: LoginPresenterOutput {
    
}
