import UIKit
import Alamofire
import SnapKit

class ViewController: UIViewController {

    let forCellReuseIdentifier: String = "customCell"
    let iso8601DateFormatter = ISO8601DateFormatter()
    var isaddload: Bool = true
    var pageNum: Int = 0

    let header: HTTPHeaders = [
        "Authorization": "Bearer f4987cf92ac8fa6be44b169e9684eccccbf6254f"
    ]

    @IBOutlet weak var tableView: UITableView!

    private var articles = [Article]()
    private var refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableViewSetup()
        getArticleInfo()
    }

    private func tableViewSetup() {
        self.view.addSubview(self.tableView)
        self.tableView.register(UINib(nibName: "CustomTableViewCell",
                                      bundle: nil),
                                forCellReuseIdentifier: self.forCellReuseIdentifier)

        self.tableView.delegate = self
        self.tableView.dataSource = self

        self.refreshControl.addTarget(self,
                                      action: #selector(self.reloadArticle),
                                      for: .valueChanged)

        self.tableView.refreshControl = self.refreshControl
    }

    @objc func reloadArticle() {
        self.getArticleInfo(reload: true) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.refreshControl.endRefreshing()
            }
        }
    }

    private func getArticleInfo(reload: Bool = false, completion: (() -> Void)? = nil) {
        self.pageNum = reload ? 1 : self.pageNum + 1

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        let parameters: [String: String] = [
            "page": "\(self.pageNum)"
        ]

        AF.request(
            "https://qiita.com/api/v2/items",
            method: .get,
            parameters: parameters,
            headers: header
        ).responseDecodable(of: [Article].self, decoder: decoder) { (reseponse) in
            if reload {
                self.articles = reseponse.value ?? []
                self.tableView.reloadData()
                self.isaddload = true
                completion?()
            } else {
                var paths = [IndexPath]()
                let count = self.articles.count

                reseponse.value?.enumerated().forEach {
                    self.articles.append($0.element)
                    paths.append(IndexPath(row: count + $0.offset, section: 0))
                }
                //            self.articles = reseponse.value
                self.tableView.beginUpdates()
                self.tableView.insertRows(at: paths, with: .left)
                self.tableView.endUpdates()
                self.isaddload = true
                completion?()
            }
        }
    }

    func transrateiSOtoJp(isoDate: String) -> String {
        let tmp: [String] = isoDate.components(separatedBy: "-")
        let date = "\(tmp[0])年\(tmp[1])月\(tmp[2])日"
        return date
    }

    func getImageByUrl(url: String) -> UIImage? {
        let url = URL(string: url)
        do {
            let data = try Data(contentsOf: url!)
            return UIImage(data: data)
        } catch let err {
            print("Error: \(err.localizedDescription)")
        }
        return UIImage()
    }
}

extension ViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.articles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: self.forCellReuseIdentifier,
                                                 for: indexPath) as? CustomTableViewCell
        let article = self.articles[indexPath.row]
        cell?.titleLabel.text = article.title
        iso8601DateFormatter.formatOptions = [.withFullDate]
        let date = iso8601DateFormatter.string(from: article.createdAt)
        cell?.createDateLabel.text = "が\(transrateiSOtoJp(isoDate: date))に発行しました"
        cell?.likesNumberLabel.text = "\(article.likesCount)"
        cell?.userIdLabel.text = article.user.id
        cell?.profileImage.image = getImageByUrl(url: article.user.profileImageUrl)
        cell?.profileImage.makeRounded()
        return cell!
    }

}

extension ViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView,
                   titleForHeaderInSection section: Int) -> String? {
        // ヘッダーの文字を返す
        return "Qiita記事"
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "webViewController")
            as? WebViewController
        nextVC?.url = self.articles[indexPath.row].url
        self.present(nextVC!, animated: true, completion: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.tableView.contentOffset.y + self.tableView.frame.size.height > self.tableView.contentSize.height && self.tableView.isDragging && isaddload {
            self.isaddload = false
            self.getArticleInfo()
        }
    }

}

extension UIImageView {
    func makeRounded() {
        self.layer.borderWidth = 0
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
}
