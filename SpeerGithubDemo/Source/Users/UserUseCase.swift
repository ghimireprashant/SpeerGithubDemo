//
//  UserUseCase.swift
//  SpeerGithubDemo
//
//  Created by Prashant Ghimire on 2023-01-06.
//

import Foundation
enum UserError: Error {
    case general
    case invalidURL
    case invalidJson
}

struct UserUseCase {
    let service: Repository

    init(service: Repository = Service()) {
        self.service = service
    }
    
    /// This function will fetch data from search api
    /// - Parameters:
    ///   - userName: user i.e login
    ///   - completion: result
    func retrieve(userName: String, completion: @escaping (Result<User, UserError>) -> Void) {
        let endpoint = Endpoint.userDetail(userName: userName)
        guard let url = endpoint.url else {
            completion(.failure(.invalidURL))
            return
        }
        let request = URLRequest(url: url)
        service.perform(request: request) { result in
            switch result {
                case .success(let data):
                    let decoder = JSONDecoder()
                    guard let posts = try? decoder.decode(User.self, from: data) else {
                        completion(.failure(.general))
                        return
                    }
                    completion(.success(posts))
                case .failure:
                    completion(.failure(.general))
            }
        }
    }
}
