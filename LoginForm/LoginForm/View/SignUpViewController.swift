//
//  SignUpViewController.swift
//  LoginForm
//
//  Created by 佐藤真 on 2021/01/06.
//

import UIKit

class SignUpViewController: UIViewController {
    @IBOutlet weak var nameForm: UITextField!
    @IBOutlet weak var userIdForm: UITextField!
    @IBOutlet weak var passwordForm: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var navLoginViewButton: UIButton!
    
    private(set) var presenter: SignUpPresenterInput!
    
    var dataController: DataController = DataController()

    
    
    func inject(presenter: SignUpPresenterInput) {
        self.presenter = presenter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        passwordForm.isSecureTextEntry = true
    }
    
    @IBAction func signUpButtonTouchUpInside(_ sender: UIButton) {
        guard let name = nameForm.text else { return }
        guard let userId = userIdForm.text else { return }
        guard let password = passwordForm.text else { return }
        
        presenter.didTapSignUpAction(name: name, userId: userId, password: password)
    }
    
    @IBAction func navLoginViewButtonTouchUpInside(_ sender: UIButton) {
        let loginVC = UIStoryboard(name: "Login", bundle: nil).instantiateInitialViewController() as! LoginViewController
        let model = UserModel(moContext: dataController.context)
        let presenter = LoginPresenter(view: loginVC, model: model)
        
        loginVC.inject(presenter: presenter)
        
        loginVC.modalPresentationStyle = .fullScreen
        self.present(loginVC, animated: true, completion: nil)
    }
}

extension SignUpViewController: SignUpPresenterOutput {
    
}

