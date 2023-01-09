//
//  ReuseIdentifiable.swift
//  SpeerGithubDemo
//
//  Created by Prashant Ghimire on 2023-01-06.
//

import Foundation
import UIKit
import SDWebImage
protocol ReuseIdentifiable {
    static var identifier: String { get }
}

extension ReuseIdentifiable {
    static var identifier: String {
        return String(describing: Self.self)
    }
}

extension UITableViewCell: ReuseIdentifiable {}

extension UIViewController: ReuseIdentifiable {}

//// MARK: - extension for sdwebimage
extension UIImageView {
    func setURLImage(imageURL: String?, placeHolder defaultImage: String = "AppIcon") {
        guard let stringURL = imageURL, let url = URL(string: stringURL) else {
            self.image = UIImage(named: defaultImage)
            return
        }
        self.sd_imageTransition = .fade
        self.sd_setShowActivityIndicatorView(true)
        self.sd_setIndicatorStyle(.gray)
        let placeHolderImage = UIImage(named: defaultImage)
        self.sd_setImage(with: url, placeholderImage: placeHolderImage)

    }
}
