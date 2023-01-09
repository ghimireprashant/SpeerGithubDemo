//
//  AppDelegate.swift
//  SpeerGithubDemo
//
//  Created by Prashant Ghimire on 2023-01-06.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.setUpInitialViewController()
        return true
    }
    
    /// This Function is for setting up initial viewController
    private func setUpInitialViewController() {
        let storyboard = UIStoryboard(name: "Search", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "UserSearchResultVC") as! UserSearchResultVC
        let navigationController = UINavigationController(rootViewController: viewController)
//        navigationController.navigationBar.prefersLargeTitles = true
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
    }

}

