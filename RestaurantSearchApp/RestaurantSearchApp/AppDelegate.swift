//
//  AppDelegate.swift
//  RestaurantSearchApp
//
//  Created by 佐藤 真 on 2020/12/04.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        UserDefaults.standard.register(defaults: [
            "RestaurantItems": [
                "トリキ",
                "サクスイ",
                "台湾料理の店",
                "千吉カレーうどん",
            ]
        ])

        let view =
            UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
            as? RestaurantListViewController
        let model = RestaurantModel()

        let presenter = RestaurantListPresenter(view: view!, model: model)

        view!.inject(presenter: presenter)

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = view
        window?.makeKeyAndVisible()

        return true
    }

}
