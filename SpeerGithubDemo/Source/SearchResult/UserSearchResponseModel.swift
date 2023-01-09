//
//  UserSearchResponseModel.swift
//  SpeerGithubDemo
//
//  Created by Prashant Ghimire on 2023-01-06.
//

import Foundation
class UserSearchResponseModel: Codable {
    let totalCount: Int?
    let result: [UserModel]?
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case result = "items"
    }
    
    /// This function will fetch data from search api
    /// - Parameters:
    ///   - searchText: search text
    ///   - completion: return result 
    class func retrieve(searchText: String, completion: @escaping (Result<Users?, UserError>) -> Void) {
        let endpoint = Endpoint.search(matching: searchText)
        print(endpoint.url?.absoluteString)
        guard let url = endpoint.url else {
            completion(.failure(.invalidURL))
            return
        }
        let request = URLRequest(url: url)
        Service().perform(request: request) { result in
            switch result {
            case .success(let data):
                let decoder = JSONDecoder()
                guard let users = try? decoder.decode(UserSearchResponseModel.self, from: data) else {
                    completion(.failure(.general))
                    return
                }
                completion(.success(users.result))
            case .failure:
                completion(.failure(.general))
            }
        }
    }
}
