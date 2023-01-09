//
//  UserSearchResultVC.swift
//  SpeerGithubDemo
//
//  Created by Prashant Ghimire on 2023-01-06.
//

import UIKit
class UserSearchResultVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    var searchText: String = ""{
        didSet {
            self.getSearch()
        }
    }
    
    var users: Users? {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    // MARK: - View cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.searchBar.delegate = self
        self.title = "Search User"
    }
    
    /// This function will fetch data from search api
    private func getSearch() {
        let textSearch = searchText.trimmingCharacters(in: .whitespaces)
        guard textSearch.count >= 3 else {return}
        UserSearchResponseModel.retrieve(searchText: textSearch) { [weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let users):
                strongSelf.users = users
            case .failure(_):
                break
            }
        }
    }
    
}
// MARK: - TableView DataSource
extension UserSearchResultVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = self.users?.count else {
            self.tableView.setEmptyMessage("Please search user using search bar on the top of the screen")
            return 0
        }
        self.tableView.restore()
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserSearchResultTVC.identifier, for: indexPath) as? UserSearchResultTVC else {
            fatalError("couldnot found cell")
        }
        cell.setView(item: self.users?[indexPath.row])
        return cell
    }
}
// MARK: - TableView Delegate
extension UserSearchResultVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let user = self.users?[indexPath.row] else {
            return
        }
        let viewModel = UserViewModel(githubUser: user.userName ?? "")
        let viewController = UserViewController(viewModel: viewModel)
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
}
// MARK: - Search Delegate
extension UserSearchResultVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.text = ""
        self.users = nil
    }
}
