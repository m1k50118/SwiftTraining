//
//  ScheduleModel.swift
//  MyCalendar
//
//  Created by 佐藤真 on 2020/12/24.
//

import Foundation
import RealmSwift

protocol ScheduleModelInput {
    func insert(object: Schedule)
}

class ScheduleModel: ScheduleModelInput {

    func insert(object: Schedule) {
        do {
            let realm: Realm = try Realm()
            print(Realm.Configuration.defaultConfiguration.fileURL!)
            try realm.write {
                realm.create(Schedule.self, value: object, update: .modified)
            }
        } catch {
            print("Realm is Error")
        }
    }
}
