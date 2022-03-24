//
//  ViewController.swift
//  CountApp
//
//  Created by 佐藤 真 on 2020/11/24.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    var num: Int = 0 {

        didSet {
            countLabel.text = "\(num)"
            numManager(num: num)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func plus(_ sender: UIButton) {
        num += 1
    }

    @IBAction func minus(_ sender: UIButton) {
        num -= 1
    }

    func numManager(num: Int) {
        if num % 10 == 0 && num != 0 {
            let dialog = UIAlertController(title: "10の倍数！", message: "", preferredStyle: .alert)

            dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

            self.present(dialog, animated: true, completion: nil)
        }
    }
}
