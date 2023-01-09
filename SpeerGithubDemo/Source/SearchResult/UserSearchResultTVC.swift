//
//  UserSearchResultTVC.swift
//  SpeerGithubDemo
//
//  Created by Prashant Ghimire on 2023-01-06.
//

import UIKit

class UserSearchResultTVC: UITableViewCell {
    @IBOutlet weak var userImageView: CircularImageVIew!
    @IBOutlet weak var userNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setView(item: User?) {
        self.userNameLabel.text = item?.userName
        self.userImageView.setURLImage(imageURL: item?.avatarUrl)
    }
}
