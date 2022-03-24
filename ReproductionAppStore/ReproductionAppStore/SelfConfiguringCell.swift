//
//  SelfConfiguringCell.swift
//  ReproductionAppStore
//
//  Created by 佐藤真 on 2021/01/05.
//

import Foundation

protocol SelfConfiguringCell {
    static var reuseIdentifier: String { get }
    func configure(with app: App)
}
