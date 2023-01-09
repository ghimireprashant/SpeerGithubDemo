//
//  AppConfigurations.swift
//  SpeerGithubDemo
//
//  Created by Prashant Ghimire on 2023-01-06.
//

import Foundation
struct Constant {
  static let perPage = 20 // per page in github api
}


//public func print(_ items: String..., filename: String = #file, function : String = #function, line: Int = #line, separator: String = " ", terminator: String = "\n") {
//    #if DEBUG
//        let pretty = "\(URL(fileURLWithPath: filename).lastPathComponent) [#\(line)] \(function)\n\t-> "
//        let output = items.map { "\($0)" }.joined(separator: separator)
//        Swift.print(pretty+output, terminator: terminator)
//    #else
//        Swift.print("RELEASEMODE")
//    #endif
//}
let githubToken = ""

struct Endpoint {
    let path: String
    let queryItems: [URLQueryItem]?
    init(path: String, queryItems: [URLQueryItem]? = nil) {
        self.path = path
        self.queryItems = queryItems
    }
}
extension Endpoint {
    static func search(matching query: String,
                       pageNo: Int = 1) -> Endpoint {
        return Endpoint(
            path: "/search/users",
            queryItems: [
                URLQueryItem(name: "q", value: query),
                URLQueryItem(name: "page", value: pageNo.description)
            ]
        )
    }
    static func userDetail(userName: String) -> Endpoint {
        return Endpoint(path: "/users/" + userName)
    }
    static func genericType(type: ViewControllerType, userName: String, pageNo: String = "1") -> Endpoint {
        switch type {
        case .following:
            return Endpoint(path: "/users/" + userName + "/following", queryItems: [ URLQueryItem(name: "per_page", value: Constant.perPage.description), URLQueryItem(name: "page", value: pageNo.description)])
        case .repo:
            return Endpoint(path: "/users/" + userName + "/repos", queryItems: [ URLQueryItem(name: "per_page", value: Constant.perPage.description), URLQueryItem(name: "page", value: pageNo.description)])
        case .follower:
            return Endpoint(path: "/users/" + userName + "/followers", queryItems: [ URLQueryItem(name: "per_page", value: Constant.perPage.description), URLQueryItem(name: "page", value: pageNo.description)])
        }
    }
}
extension Endpoint {
    // We still have to keep 'url' as an optional, since we're
    // dealing with dynamic components that could be invalid.
    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.github.com"
        components.path = path
        components.queryItems = queryItems
        return components.url
    }
}
