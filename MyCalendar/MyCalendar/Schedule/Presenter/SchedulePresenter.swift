//
//  SchedulePresenter.swift
//  MyCalendar
//
//  Created by 佐藤真 on 2020/12/24.
//

import Foundation

protocol SchedulePresenterInput {
    func didTapAvailabilityButtion(availability: Bool)
}

protocol SchedulePresenterOutput: AnyObject {
    func disMissSchedule()
}

final class SchedulePresenter: SchedulePresenterInput {
    private var date: String
    private(set) var schedule = Schedule()
    private var view: SchedulePresenterOutput!
    private var model: ScheduleModelInput

    init(date: String, view: SchedulePresenterOutput, model: ScheduleModelInput) {
        self.date = date
        self.view = view
        self.model = model
    }

    func didTapAvailabilityButtion(availability: Bool) {
        self.schedule.date = self.date
        self.schedule.availability = availability

        model.insert(object: self.schedule)
    }
}
