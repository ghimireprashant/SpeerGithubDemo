//
//  UserModel.swift
//  SpeerGithubDemo
//
//  Created by Prashant Ghimire on 2023-01-06.
//

import Foundation
struct UserModel: Codable {
    let userName, avatarUrl, company, location, blog, name : String?
    let followers, following, publicRepo: Int?
    
    enum CodingKeys: String, CodingKey {
        case userName = "login"
        case avatarUrl = "avatar_url"
        case company = "company"
        case location
        case blog
        case name
        case followers = "followers"
        case following = "following"
        case publicRepo = "public_repos"
    }
}
typealias User = UserModel
typealias Users = [UserModel]
