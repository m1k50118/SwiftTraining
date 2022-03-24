//
//  App.swift
//  ReproductionAppStore
//
//  Created by 佐藤真 on 2021/01/05.
//

import Foundation

struct App: Decodable, Hashable {
    let id: Int
    let tagline: String
    let name: String
    let subheading: String
    let image: String
    let iap: Bool
}
