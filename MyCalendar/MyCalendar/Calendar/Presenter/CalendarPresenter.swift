//
//  CalendarPresenter.swift
//  MyCalendar
//
//  Created by 佐藤 真 on 2020/12/14.
//

import Foundation

// MARK:- Protocol
protocol CalendarPresenterInput {
    var numberOfDates: Int { get }
    var weekSymbols: [String] { get }
    func viewDidLoad()
    func conversionDateFormatOnlyDay(forRow row: Int) -> String
    func moveMonth(count: Int)
    func getMonthSymbol() -> String
    func dateIsThisMonthOrNot(forRow row: Int) -> Bool
    func didSelectRow(at indexPath: IndexPath)
    func isAvailable(forRow row: Int) -> Schedule?
    func deleteAction(forRow row: Int)
}

protocol CalendarPresenterOutput: AnyObject {
    func updateDates()
    func updateLabel()
    func transitionToSchedule(date: String)
}

class CalendarPresenter: CalendarPresenterInput {
    // MARK:- Properties
    private var view: CalendarPresenterOutput!
    private var model: CalendarModelInput

    private(set) var dates: [Date] = []

    var numberOfDates: Int {
        return dates.count
    }
    var weekSymbols: [String] {
        return model.weekdaySymbols
    }

    private var monthSymbol: String = ""
    var scheduleAvailability: Bool = false

    // MARK:- Initialize
    init(view: CalendarPresenterOutput, model: CalendarModelInput) {
        self.view = view
        self.model = model
    }

    // MARK:- Functions

    /// Dateを文字列に変換
    /// - Parameter indexPath: 表示する日付のインデックス
    /// - Returns: 文字列に変換した日付
    func conversionDateFormatOnlyDay(forRow row: Int) -> String {
        let f = DateFormatter()
        f.setTemplate(.onlyDay)
        return f.string(from: dates[row])
    }

    /// Modelに次月・前月の計算を依頼
    /// - Parameter count: 移動する月の数
    func moveMonth(count: Int) {
        model.moveMonth(count: count) {
            self.dates = model.fetchItems()
            self.monthSymbol = model.fetchMonthSymbol()
            view.updateLabel()
            view.updateDates()
        }
    }

    /// 月の名前を取得する
    /// - Returns: 表示する月の名前を返す
    func getMonthSymbol() -> String {
        return self.monthSymbol
    }

    /// 表示している月かどうか
    /// - Parameter indexPath: 表示する日付のインデックス
    /// - Returns: 真偽値
    func dateIsThisMonthOrNot(forRow row: Int) -> Bool {
        model.dateIsThisMonthOrNot(date: dates[row])
    }

    func conversionDateFormatShort(date: Date) -> String {
        let f = DateFormatter()
        f.setTemplate(.date)
        return f.string(from: date)
    }

    func date(forRow row: Int) -> Date? {
        guard row < dates.count else { return nil }
        return dates[row]
    }

    func didSelectRow(at indexPath: IndexPath) {
        guard let date = date(forRow: indexPath.row) else {
            return
        }
        view.transitionToSchedule(date: conversionDateFormatShort(date: date))
    }

    func isAvailable(forRow row: Int) -> Schedule? {
        guard let date = date(forRow: row) else { return nil }
        return model.searchOne(date: conversionDateFormatShort(date: date))
    }

    func deleteAction(forRow row: Int) {
        guard let date = date(forRow: row) else {
            return
        }
        model.deleteSchedule(date: conversionDateFormatShort(date: date), completion: view.updateDates)
    }

    // MARK:- Life Cycle
    func viewDidLoad() {
        model.registerDateofCalendar(
            date: Date(),
            completion: {
                self.dates = model.fetchItems()
                self.monthSymbol = model.fetchMonthSymbol()
                view.updateDates()
                view.updateLabel()
            })
    }
}
