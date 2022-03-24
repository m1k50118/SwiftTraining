//
//  ViewController.swift
//  RestaurantSearchApp
//
//  Created by 佐藤 真 on 2020/12/04.
//

import Alamofire
import CoreLocation
import UIKit

class ViewController: UIViewController, CLLocationManagerDelegate {

    var parameters: [String: String] = [
        "keyid": "1ebf65d6bdf0d741bbe976c4d835ae26"
    ]

    var locationManager: CLLocationManager? = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupLocationManager()
    }

    //    private func getRestaurantInfo() {
    //        AF.request("https://api.gnavi.co.jp/RestSearchAPI/v3/",
    //                   method: .get,
    //                   parameters: <#T##Encodable?#>,
    //                   encoder: <#T##ParameterEncoder#>,
    //                   headers: <#T##HTTPHeaders?#>,
    //                   interceptor: <#T##RequestInterceptor?#>,
    //                   requestModifier: <#T##Session.RequestModifier?##Session.RequestModifier?##(inout URLRequest) throws -> Void#>)
    //    }

    func setupLocationManager() {
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let first = locations.first else {
            return
        }

        print(first.coordinate.latitude)
        print(first.coordinate.longitude)
    }
}
