//
//  ScheduleModel.swift
//  MyCalendar
//
//  Created by 佐藤真 on 2020/12/24.
//
import Foundation
import RealmSwift

class Schedule: Object {
    @objc dynamic var date: String?
    @objc dynamic var availability: Bool = false

    override static func primaryKey() -> String? {
        return "date"
    }
}
