//
//  LoginPresenter.swift
//  LoginForm
//
//  Created by 佐藤真 on 2021/01/08.
//

import Foundation

protocol LoginPresenterInput {
    func didTapLoginButton(userId: String, password: String) -> Bool
}

protocol LoginPresenterOutput: AnyObject {
    
}

class LoginPresenter: LoginPresenterInput {
    private weak var view: LoginPresenterOutput!
    private var model: UserModelInput
    
    init(view: LoginPresenterOutput, model: UserModelInput) {
        self.view = view
        self.model = model
    }
    
    func didTapLoginButton(userId: String, password: String) -> Bool {
        return model.findUser(userId: userId, password: password).isEmpty
    }
}
