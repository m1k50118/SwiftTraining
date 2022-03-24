//
//  Section.swift
//  ReproductionAppStore
//
//  Created by 佐藤真 on 2021/01/05.
//

import Foundation

struct Section: Decodable, Hashable {
    let id: Int
    let type: String
    let title: String
    let subtitle: String
    let items: [App]

}
