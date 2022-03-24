//
//  Article.swift
//  QittaAPITableViewApp
//
//  Created by 佐藤 真 on 2020/11/30.
//

import Foundation

struct User: Codable {
    let id: String
    let profileImageUrl: String
}

struct Article: Codable {
    let createdAt: Date
    let likesCount: Int
    let title: String
    let url: String
    let user: User

}
