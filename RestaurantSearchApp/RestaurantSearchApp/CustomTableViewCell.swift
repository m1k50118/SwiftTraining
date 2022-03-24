//
//  CustomTableViewCell.swift
//  RestaurantSearchApp
//
//  Created by 佐藤 真 on 2020/12/04.
//

import MapKit
import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet var restaurantNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
