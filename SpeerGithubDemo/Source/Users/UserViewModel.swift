//
//  UserViewModel.swift
//  SpeerGithubDemo
//
//  Created by Prashant Ghimire on 2023-01-06.
//

import Foundation
protocol UserViewModellDelegate: AnyObject {
    func refreshDisplay(_ viewModle: UserViewModel)
}
final class UserViewModel {
    var githubUser: String = "ghimireprashant"
    enum ScreenState {
        case loading(message: String)
        case success(user: User)
        case error(message: String)
    }

    private let useCase: UserUseCase

    weak var delegate: UserViewModellDelegate?

    init(githubUser: String = "ghimireprashant", useCase: UserUseCase = UserUseCase()) {
        self.useCase = useCase
        self.githubUser = githubUser
    }

    private(set) var state: ScreenState = .loading(message: "Loading") {
        didSet {
            delegate?.refreshDisplay(self)
        }
    }
    func viewDidLoad() {
        ProgressHud.showProgressHUD()
        useCase.retrieve(userName: githubUser) { [weak self] result in
            ProgressHud.hideProgressHUD()
            guard let self = self else { return }
            switch result {
                case .success(let user):
                self.state = .success(user: user)
                case .failure:
                    self.state = .error(message: "Error")
            }
        }
    }
}
