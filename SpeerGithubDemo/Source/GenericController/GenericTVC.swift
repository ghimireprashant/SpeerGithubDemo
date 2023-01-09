//
//  GenericTVC.swift
//  SpeerGithubDemo
//
//  Created by Prashant Ghimire on 2023-01-08.
//

import Foundation
import UIKit
class GenericTVC: UITableViewCell {
    @IBOutlet weak var artworkImageView: CircularImageVIew!
    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    /// This function is for setup view in tableview cell
    /// - Parameters:
    ///   - type: type of viewcontroller
    ///   - item: item detail
    func setView(type: ViewControllerType, item: GenericModel?) {
        self.artworkImageView.setURLImage(imageURL: item?.artwork)
        self.artworkImageView.isHidden = !(type != .repo)
        self.nameLabel.attributedText = item?.attributedString
    }
}
