//
//  UserViewController.swift
//  SpeerGithubDemo
//
//  Created by Prashant Ghimire on 2023-01-06.
//

import UIKit

class UserViewController: UIViewController {

    @IBOutlet weak var userFullNameLabel: UILabel!
    @IBOutlet weak var userNamelabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!

    @IBOutlet weak var userLocationLabel: UILabel!
    @IBOutlet weak var userLocationStackView: UIStackView!

    @IBOutlet weak var userLinkLabel: UILabel!
    @IBOutlet weak var userLinkStackView: UIStackView!

    @IBOutlet weak var userCompanyStackView: UIStackView!
    @IBOutlet weak var userCompanyLabel: UILabel!

    @IBOutlet weak var userFollowerLabel: UILabel!
    @IBOutlet weak var userFollowerStackView: UIStackView!

    @IBOutlet weak var repoCountLabel: UILabel!
    
    let viewModel: UserViewModel
    
    /// Init with view model
    /// - Parameter viewModel: viewmodel
    init(viewModel: UserViewModel) {
        self.viewModel = viewModel
        super.init(nibName: UserViewController.identifier, bundle: nil)
        self.viewModel.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUp()
    }
    
    /// This function is for setup
    private func setUp() {
        self.viewModel.viewDidLoad()
        self.title = self.viewModel.githubUser.capitalized
        userFollowerLabel.isUserInteractionEnabled = true
        userFollowerLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapOnLabel(_:))))
    }

    /// This function  is for navigation on action
    /// - Parameters:
    ///   - type: ViewController type
    ///   - user: Github login
    func pushToGeneric(type: ViewControllerType, user: String) {
        let story = UIStoryboard(name: "Generic", bundle: nil)
        let controller = story.instantiateViewController(withIdentifier: GenericViewController.identifier) as! GenericViewController
        controller.controllerType = type
        controller.githubUser = user
        self.navigationController?.pushViewController(controller, animated: true)
    }

    // MARK: - Action
    @IBAction func repoAction(_ sender: Any) {
        pushToGeneric(type: .repo, user: viewModel.githubUser)
    }
}
extension UserViewController: UserViewModellDelegate {
    func refreshDisplay(_ viewModle: UserViewModel) {
        switch self.viewModel.state {
        case .error(let message):break
        case .success(let user):
            viewSetUpForUser(user: user)
        case .loading(let message): break
        }
    }
    /// This function will setup data to view
    /// - Parameter user: user detail
    private func viewSetUpForUser(user: User) {
        self.userImageView.setURLImage(imageURL: user.avatarUrl)
        self.repoCountLabel.text = "\(user.publicRepo ?? 0)"
        validateView(text: user.name, textLabel: userFullNameLabel, inStackView: nil)
        validateView(text: user.userName, textLabel: userNamelabel, inStackView: nil)
        validateView(text: user.location, textLabel: userLocationLabel, inStackView: userLocationStackView)
        validateView(text: user.company, textLabel: userCompanyLabel, inStackView: userCompanyStackView)
        validateView(text: user.blog, textLabel: userLinkLabel, inStackView: userLinkStackView)
    
          let mutableAttribute = AttributedString()
        mutableAttribute.text("\(user.followers ?? 0) ").text("followres", attributes: [.textColor(UIColor.gray), .underline(true)]).text(" . ").text("\(user.following ?? 0) ").text("following", attributes: [.textColor(UIColor.gray), .underline(true)]).tabs(1)
        self.userFollowerLabel.attributedText = mutableAttribute.attributedString
    }
    
    /// This function will handle gesture
    /// - Parameter gesture:
    @objc func handleTapOnLabel(_ gesture: UITapGestureRecognizer) {
        if gesture.didTapAttributedString("following", in: userFollowerLabel) {
            pushToGeneric(type: .following, user: viewModel.githubUser)
        } else if gesture.didTapAttributedString("followres", in: userFollowerLabel) {
            pushToGeneric(type: .follower, user: viewModel.githubUser)
        }
    }
    
    /// This function will validate view and set text to label
    /// - Parameters:
    ///   - text: text
    ///   - textLabel: label
    ///   - inStackView: stackview
    private func validateView(text: String?, textLabel: UILabel, inStackView: UIStackView? = nil) {
        guard let text = text, text != "" else {
            inStackView?.isHidden = true
            return
        }
        textLabel.text = text
    }
}
