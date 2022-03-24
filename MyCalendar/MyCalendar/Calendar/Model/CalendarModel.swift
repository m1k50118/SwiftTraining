//
//  CalendarModel.swift
//  MyCalendar
//
//  Created by 佐藤 真 on 2020/12/14.
//

import Foundation
import RealmSwift

// MARK:- Protocol
protocol CalendarModelInput {
    var weekdaySymbols: [String] { get }
    func fetchItems() -> [Date]
    func fetchMonthSymbol() -> String
    func firstDateOfCalendar(date: Date) -> Date
    func numberOfCellsPerMonth(date: Date) -> Int
    func registerDateofCalendar(date: Date, completion: () -> Void)
    func monthSymbol(date: Date)
    func moveMonth(count: Int, completion: () -> Void)
    func dateIsThisMonthOrNot(date: Date) -> Bool
    func searchOne(date: String) -> Schedule?
    func deleteSchedule(date: String, completion: () -> Void)
}

class CalendarModel: CalendarModelInput {
    // MARK:- Properties
    private let calendar: Calendar
    private var currentMonthOfDates: [Date] = []
    private let daysPerWeek: Int = 7
    private var numberOfItems: Int!
    private var monthCount: Int = 0
    private var monthSymbol: String = ""
    private var ordinalityOfFirstDay: Int?

    var weekdaySymbols: [String] {
        return calendar.shortWeekdaySymbols
    }

    // MARK:- Initialize
    init(calendar: Calendar) {
        self.calendar = calendar
    }

    // MARK:- Functions
    func fetchItems() -> [Date] {
        return self.currentMonthOfDates
    }

    func fetchMonthSymbol() -> String {
        return self.monthSymbol
    }
    /// 指定の日付の月名を取得する
    /// - Parameter date: 今日の日付または次月・前月の日付
    func monthSymbol(date: Date) {
        let monthSymbols = calendar.monthSymbols
        let month = calendar.component(.month, from: date)

        self.monthSymbol = monthSymbols[month - 1]
    }

    /// 月毎のセル数を返すメソッド
    /// - Parameter date: 今日の日付または次月・前月の日付
    /// - Returns: 表示するセルの数
    func numberOfCellsPerMonth(date: Date) -> Int {
        let rangeOfWeeks = calendar.range(
            of: .weekOfMonth, in: .month, for: firstDateOfCalendar(date: date))
        let numberOfWeeks = rangeOfWeeks?.count
        self.numberOfItems = numberOfWeeks! * self.daysPerWeek

        return numberOfItems
    }

    /// カレンダー上の初日を取得
    /// - Parameter date: 今日の日付または次月・前月の日付
    /// - Returns: カレンダー上で最初の日付
    func firstDateOfCalendar(date: Date) -> Date {
        var components = calendar.dateComponents([.year, .month, .day], from: date)
        components.day = 1
        let firstDateMonth = Calendar.current.date(from: components)!

        return firstDateMonth
    }

    /// 月のカレンダーの日付を取得
    /// - Parameters:
    ///   - date: 今日の日付または次月・前月の日付
    ///   - completion: Presenterに完了を伝える
    func registerDateofCalendar(date: Date, completion: () -> Void) {
        ordinalityOfFirstDay = calendar.ordinality(
            of: .day, in: .weekOfMonth, for: firstDateOfCalendar(date: date))

        for i in 0..<numberOfCellsPerMonth(date: date) {
            var dateComponents = DateComponents()
            dateComponents.day = i - (ordinalityOfFirstDay! - 1)

            if let date = Calendar.current.date(
                byAdding: dateComponents, to: firstDateOfCalendar(date: date), wrappingComponents: false)
            {
                self.currentMonthOfDates.append(date)
            }
        }
        monthSymbol(date: date)
        completion()
    }

    /// 前月・次月を取得
    /// - Parameters:
    ///   - count: 表示する月を-1or+1する
    ///   - completion: Presenterに完了を伝える
    func moveMonth(count: Int, completion: () -> Void) {
        monthCount += count
        currentMonthOfDates = []
        let moveDate = calendar.date(byAdding: .month, value: monthCount, to: Date())
        registerDateofCalendar(date: moveDate!) {
            monthSymbol(date: moveDate!)
            completion()
        }
    }

    /// 与えられた日付が表示しているカレンダーの月かどうかの判定
    /// - Parameter date: 表示する日付
    /// - Returns: true or false
    func dateIsThisMonthOrNot(date: Date) -> Bool {
        return calendar.isDate(date, equalTo: currentMonthOfDates[ordinalityOfFirstDay!], toGranularity: .month)
    }

    func searchOne(date: String) -> Schedule? {
        do {
            let realm: Realm = try Realm()
            let data: Schedule? = realm.objects(Schedule.self).filter("date=='\(date)'").first
            return data
        } catch {
            print("Realm is Error")
        }
        return nil
    }

    func deleteSchedule(date: String, completion: () -> Void) {
        do {
            let realm = try Realm()
            let data = searchOne(date: date)

            try realm.write {
                realm.delete(data!)
            }
        } catch {
            print("Realm is Error")
        }
        completion()
    }
}

extension DateFormatter {
    enum Template: String {
        case date = "yMd"
        case onlyDay = "d"
    }

    func setTemplate(_ template: Template) {
        dateFormat = DateFormatter.dateFormat(fromTemplate: template.rawValue, options: 0, locale: .current)
    }
}
