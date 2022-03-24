//
//  RestaurantListPresenter.swift
//  RestaurantSearchApp
//
//  Created by 佐藤 真 on 2020/12/10.
//

import Foundation

protocol RestaurantListPresenterInput {

    var numberOfRestaurants: Int { get }

    func getRest(forRow row: Int) -> Rest?
    func viewDidLoad()
}

protocol RestaurantListPresenterOutput: AnyObject {

    func updateRestaurant()
}

final class RestaurantListPresenter: RestaurantListPresenterInput {

    private(set) var restaurants: [Rest] = []

    private weak var view: RestaurantListPresenterOutput!
    private var model: RestaurantModelInput

    init(view: RestaurantListPresenterOutput, model: RestaurantModelInput) {
        self.view = view
        self.model = model
    }

    var numberOfRestaurants: Int {
        return restaurants.count
    }

    func getRest(forRow row: Int) -> Rest? {
        guard row < restaurants.count else {
            return nil
        }

        return restaurants[row]
    }

    func viewDidLoad() {
        model.getRestaurant { (result) in
            self.restaurants = result
            self.view.updateRestaurant()
        }
    }
}
