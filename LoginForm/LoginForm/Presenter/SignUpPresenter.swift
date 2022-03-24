//
//  SignUpPresenter.swift
//  LoginForm
//
//  Created by 佐藤真 on 2021/01/06.
//

import Foundation

protocol SignUpPresenterInput {
    func didTapSignUpAction(name: String, userId: String, password: String)
}

protocol SignUpPresenterOutput: AnyObject {
    
}

final class SignUpPresenter: SignUpPresenterInput {
    private weak var view: SignUpPresenterOutput!
    private(set) var model: UserModelInput
    
    init(view: SignUpPresenterOutput, model: UserModelInput) {
        self.view = view
        self.model = model
    }
    
    func didTapSignUpAction(name: String, userId: String, password: String) {
        model.registerUser(name: name, userId: userId, password: password)
    }
}
