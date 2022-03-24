//
//  CalendarViewController.swift
//  MyCalendar
//
//  Created by 佐藤 真 on 2020/12/14.
//

import UIKit

class CalendarViewController: UIViewController {
    private var presenter: CalendarPresenterInput!
    func inject(presenter: CalendarPresenterInput) {
        self.presenter = presenter
    }

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var label: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // スワイプのジェスチャーを追加
        let rightSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swiped(_:)))
        rightSwipeGesture.direction = .right
        view.addGestureRecognizer(rightSwipeGesture)
        let leftSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swiped(_:)))
        leftSwipeGesture.direction = .left
        view.addGestureRecognizer(leftSwipeGesture)

        // 長押しのジェスチャーを追加
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressed(_:)))
        self.collectionView.addGestureRecognizer(longPressGesture)

        collectionView.dataSource = self
        collectionView.delegate = self

        presenter.viewDidLoad()
    }

    /// スワイプした時の処理
    /// - Parameter sender: スワイプのジェスチャー
    @objc func swiped(_ sender: UISwipeGestureRecognizer) {
        switch sender.direction {
        case .left:
            presenter.moveMonth(count: 1)
        case .right:
            presenter.moveMonth(count: -1)
        default:
            break
        }
    }

    @objc func longPressed(_ sender: UILongPressGestureRecognizer) {
        let point = sender.location(in: collectionView)

        guard let indexPath = collectionView.indexPathForItem(at: point) else {
            return
        }
        if sender.state == .began {
            if collectionView.numberOfSections != 0 {
                if presenter.dateIsThisMonthOrNot(forRow: indexPath.row) {
                    if presenter.isAvailable(forRow: indexPath.row) != nil {
                        let alert = UIAlertController(title: "アラート表示", message: "予定を削除しますか？", preferredStyle: .alert)
                        let deleatAction = UIAlertAction(title: "削除する", style: .destructive) { (UIAlertAction) in
                            self.presenter.deleteAction(forRow: indexPath.row)
                        }
                        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
                        alert.addAction(deleatAction)
                        alert.addAction(cancelAction)

                        present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
    }
}

extension CalendarViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? 7 : (presenter.numberOfDates)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)

        if let label = cell.contentView.viewWithTag(1) as? UILabel {
            label.textColor = .systemGray
            label.sizeToFit()
            cell.backgroundColor = .none

            guard indexPath.section == 0 else {
                label.text = presenter.conversionDateFormatOnlyDay(forRow: indexPath.row)
                guard presenter.dateIsThisMonthOrNot(forRow: indexPath.row) else {
                    label.textColor = .systemGray6
                    return cell
                }
                guard let schedule = presenter.isAvailable(forRow: indexPath.row) else { return cell }
                cell.backgroundColor = schedule.availability ? .systemBlue : .systemPink

                return cell
            }

            label.text = presenter.weekSymbols[indexPath.row]
        }

        return cell
    }

}

extension CalendarViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1 && presenter.dateIsThisMonthOrNot(forRow: indexPath.row) {
            presenter.didSelectRow(at: indexPath)
        }
    }
}

extension CalendarViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let weekWidth = Int(collectionView.frame.width) / presenter.weekSymbols.count
        let weekHeight = weekWidth
        let dayWidth = weekWidth
        let dayHeight = Int(collectionView.frame.width) / presenter.weekSymbols.count

        return indexPath.section == 0 ? CGSize(width: weekWidth, height: weekHeight) : CGSize(width: dayWidth, height: dayHeight)
    }

    func collectionView(
        _ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        let surplus = Int(collectionView.frame.width) % presenter.weekSymbols.count
        let margin = CGFloat(surplus) / 2.0
        return UIEdgeInsets(top: 0.0, left: margin, bottom: 1.5, right: margin)
    }

    func collectionView(
        _ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 0.5
    }

    func collectionView(
        _ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 0
    }
}

extension CalendarViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        collectionView.reloadData()
    }
}

extension UITraitCollection {
    public class func dynamicColor(light: UIColor, dark: UIColor) -> UIColor {
        if #available(iOS 13, *) {
            return UIColor { (traitCollection) -> UIColor in
                if traitCollection.userInterfaceStyle == .dark {
                    return dark
                } else {
                    return light
                }
            }
        }
        return light
    }
}

extension CalendarViewController: CalendarPresenterOutput {
    func updateDates() {
        collectionView.reloadData()
    }

    func updateLabel() {
        label.text = presenter.getMonthSymbol()
        label.textColor = .systemGray
    }

    func transitionToSchedule(date: String) {
        let scheduleVC =
            UIStoryboard(name: "Schedule", bundle: nil).instantiateInitialViewController() as! ScheduleViewController
        scheduleVC.presentationController?.delegate = self
        let model = ScheduleModel()
        let presenter = SchedulePresenter(date: date, view: scheduleVC, model: model)
        scheduleVC.inject(presenter: presenter)

        present(scheduleVC, animated: true, completion: nil)
    }
}
