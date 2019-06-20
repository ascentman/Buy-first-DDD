//
//  Router.swift
//  Buy first DDD
//
//  Created by user on 6/20/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

final class Router {

    private let tabBarController = UITabBarController()
    private var mainViewController: MainTableViewController?
    private var mainViewControllerPresenter: MainViewControllerPresenter?
    private var mainViewControllerInteractor: MainViewControllerInteractor?

    var rootViewController: UIViewController {
        return tabBarController
    }

    // MARK: - Public

    func start() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let mainViewContoller = storyboard.instantiateViewController(withIdentifier: "MainTableViewController") as? MainTableViewController else {
            return
        }

        // tabBar view controllers
        let firstTabBarController = UINavigationController(rootViewController: mainViewContoller)
        tabBarController.viewControllers = [firstTabBarController]

        // tabBar items
        let item1 = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        firstTabBarController.tabBarItem = item1

        mainViewController = mainViewContoller
        let presenter = MainViewControllerPresenter(viewController: mainViewContoller)
        mainViewControllerInteractor = MainViewControllerInteractor(presenter: presenter)
        mainViewControllerPresenter = presenter
    }
}
