//
//  RestaurantModel.swift
//  RestaurantSearchApp
//
//  Created by 佐藤 真 on 2020/12/10.
//

import Alamofire
import Foundation

protocol RestaurantModelInput {

    func getRestaurant(completion: @escaping ([Rest]) -> Void)
}

struct APIResult: Codable {
    var rest: [Rest]
}
struct Rest: Codable {
    var name: String
    var url: String
}

class RestaurantModel: RestaurantModelInput {
    private let seacretValue: SeacretValue = SeacretValue()
    private let url: String = "https://api.gnavi.co.jp/RestSearchAPI/v3/"
    private let latitude = "35.6867406"
    private let longitude = "139.6944659"
    private var parameters: [String: String] = [:]

    func setUpParameters() {
        parameters = [
            "keyid": seacretValue.keyId,
            "latitude": self.latitude,
            "longitude": self.longitude,
        ]
    }

    func getRestaurant(completion: @escaping ([Rest]) -> Void) {
        setUpParameters()

        AF.request(url, method: .get, parameters: parameters, headers: nil, interceptor: nil, requestModifier: nil)
            .responseDecodable(of: APIResult.self) { (response) in

                completion(response.value!.rest)
            }
    }
}
