//
//  RestaurantListViewController.swift
//  RestaurantSearchApp
//
//  Created by 佐藤 真 on 2020/12/10.
//

import Foundation
import SafariServices
import UIKit

class RestaurantListViewController: UIViewController {

    private var presenter: RestaurantListPresenterInput!
    let forCellReuseIdentifier: String = "restaurantViewCell"

    func inject(presenter: RestaurantListPresenterInput) {
        self.presenter = presenter
    }

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(
            UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: forCellReuseIdentifier)

        tableView.dataSource = self
        tableView.delegate = self

        presenter.viewDidLoad()
    }
}

extension RestaurantListViewController: RestaurantListPresenterOutput {
    func updateRestaurant() {
        tableView.reloadData()
    }
}

extension RestaurantListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRestaurants
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell =
                tableView.dequeueReusableCell(
                    withIdentifier: forCellReuseIdentifier,
                    for: indexPath) as? CustomTableViewCell
        else {
            return UITableViewCell()
        }
        cell.restaurantNameLabel.text = presenter.getRest(forRow: indexPath.row)?.name

        return cell
    }
}

extension RestaurantListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let url = URL(string: presenter.getRest(forRow: indexPath.row)!.url) {
            let vc = SFSafariViewController(url: url)
            present(vc, animated: true, completion: nil)

        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
