//
//  UserSearchResultVC.swift
//  SpeerGithubDemo
//
//  Created by Prashant Ghimire on 2023-01-06.
//

import UIKit

class UserSearchResultVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

}

extension UserSearchResultVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserSearchResultTVC.identifier, for: indexPath) as? UserSearchResultTVC else {
            fatalError("couldnot found cell")
        }
        cell.userNameLabel.text = "username \(indexPath.row)"
        return cell
    }
    
    
}
