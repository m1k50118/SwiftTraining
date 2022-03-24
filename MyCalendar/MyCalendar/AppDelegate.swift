//
//  AppDelegate.swift
//  MyCalendar
//
//  Created by 佐藤 真 on 2020/12/14.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // 最初に表示する画面についてのView, Model, Presenterのインスタンスを生成
        let view = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! CalendarViewController
        let model = CalendarModel(calendar: Calendar.current)
        // PresenterとView、PresenterとModelは初期化時に紐づけられる
        let presenter = CalendarPresenter(view: view, model: model)
        // ViewとPresenterを紐づける
        view.inject(presenter: presenter)

        // 最初に表示する画面を設定
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = view
        window?.makeKeyAndVisible()
        // Override point for customization after application launch.
        return true
    }

}
