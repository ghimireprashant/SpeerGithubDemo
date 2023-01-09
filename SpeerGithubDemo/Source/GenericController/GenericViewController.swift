//
//  GenericViewController.swift
//  SpeerGithubDemo
//
//  Created by Prashant Ghimire on 2023-01-08.
//

import UIKit
import SafariServices

enum ViewControllerType: String {
    case repo = "Repository"
    case following = "Following"
    case follower = "Follower"
}

class GenericViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let refreshControl = UIRefreshControl()

    var data: [GenericModel]? {
        didSet {
            self.tableView.reloadData()
        }
    }

    var numberOfPage: Int = 0
    var loadMore: Bool = false

    var controllerType: ViewControllerType = .repo
    var githubUser: String = "ghimireprashant"

    // MARK: - View cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "\(githubUser)'s \(controllerType.rawValue)"
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl) // not required when using UITableViewController
        loadData()
    }
    
    @objc func refresh(_ sender: AnyObject) {
        self.numberOfPage = 1
        self.loadMore = false
        self.loadData()
    }
    
    /// This function is to fetch data for this controller from api
    /// - Parameters:
    ///   - pageNo: page no
    ///   - loadmore: check if there is more data 
    private func loadData(pageNo: Int = 1, loadmore: Bool = false) {
        GenericResponseModel.getData(type: controllerType, gitUser: githubUser, pageNo: numberOfPage.description, loadMore: loadmore) {[weak self] result in
            guard let strongSelf = self else {return}
            strongSelf.refreshControl.endRefreshing()
            strongSelf.tableView.tableFooterView = nil
            strongSelf.tableView.tableFooterView?.isHidden = true
            switch result {
            case .success(let data):
                if !loadmore {
                    strongSelf.data = data
                } else {
                    if  let data = data {
                        for item in data {
                            strongSelf.data?.append(item)
                        }
                    }
                }
                if data?.count ?? 0 < Constant.perPage {
                    strongSelf.loadMore = false
                } else {
                    strongSelf.loadMore = true
                    strongSelf.numberOfPage += 1
                }
            case .failure(let error):break
            }
        }
    }
}
// MARK: - TableView DataSource
extension GenericViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = self.data?.count, count > 0 else {
            self.tableView.setEmptyMessage("No \(self.controllerType.rawValue)")
            return 0
        }
        self.tableView.restore()
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GenericTVC.identifier, for: indexPath) as? GenericTVC else {
            fatalError("couldnot found cell")
        }
        cell.setView(type: controllerType, item: self.data?[indexPath.row])
        return cell
    }
}
// MARK: - TableView Delegate
extension GenericViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch controllerType {
        case .repo:
            guard let urlString = self.data?[indexPath.row].url, let url = URL(string: urlString)  else {
                return
            }
            let safariController = SFSafariViewController(url: url)
//            safariController.transitioningDelegate = self //use default modal presentation instead of push
            present(safariController, animated: true, completion: nil)
        default:
            guard let user = self.data?[indexPath.row] else {
                return
            }
            let viewModel = UserViewModel(githubUser: user.name ?? "")
            let viewController = UserViewController(viewModel: viewModel)
            self.navigationController?.pushViewController(viewController, animated: true)
            break
        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
      guard loadMore == true, let totalCount = self.data?.count, indexPath.row == totalCount - 1  else {return}
      let lastSectionIndex = tableView.numberOfSections - 1
      let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
      if indexPath.section == lastSectionIndex && indexPath.row == lastRowIndex {
        let spinner = UIActivityIndicatorView(style: .gray)
        spinner.startAnimating()
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
        self.tableView.tableFooterView = spinner
        self.tableView.tableFooterView?.isHidden = false
      }
        loadData(pageNo: numberOfPage, loadmore: loadMore)
    }
}
