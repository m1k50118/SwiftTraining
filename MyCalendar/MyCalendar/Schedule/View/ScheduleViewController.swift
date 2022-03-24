//
//  ScheduleViewController.swift
//  MyCalendar
//
//  Created by 佐藤真 on 2020/12/18.
//

import UIKit

class ScheduleViewController: UIViewController {

    @IBOutlet weak var available: UIButton!
    @IBOutlet weak var unavailable: UIButton!
    private var presenter: SchedulePresenterInput!

    func inject(presenter: SchedulePresenterInput) {
        self.presenter = presenter
    }

    var selectedCell: UICollectionViewCell?

    /// 「空いてる」ボタンを押した時の処理
    /// - Parameter sender: 空いてるボタン
    @IBAction func availableButtonAction(_ sender: UIButton) {
        presenter.didTapAvailabilityButtion(availability: true)
        disMissSchedule()
    }

    /// 「空いてない」ボタンを押した時の処理
    /// - Parameter sender: 空いてないボタン
    @IBAction func unavailableButtonAction(_ sender: UIButton) {
        presenter.didTapAvailabilityButtion(availability: false)
        disMissSchedule()
    }
}

extension ScheduleViewController: SchedulePresenterOutput {
    func disMissSchedule() {
        let calendarVC = self.presentingViewController as! CalendarViewController
        calendarVC.updateDates()
        self.dismiss(animated: true, completion: nil)
    }
}
