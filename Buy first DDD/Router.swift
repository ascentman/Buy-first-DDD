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
    private var mainViewController: MainViewController?
    private var mainViewControllerPresenter: MainViewControllerPresenter?
    private var mainViewControllerInteractor: MainViewControllerInteractor?

    var rootViewController: UIViewController {
        return tabBarController
    }

    // MARK: - Public

    func start() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let mainViewContoller = storyboard.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController else {
            return
        }

        // tab bar view controllers
        let firstTabBarController = UINavigationController(rootViewController: mainViewContoller)
        tabBarController.viewControllers = [firstTabBarController]

        // tab bar items
        let item1 = UITabBarItem(title: "Search", image: nil, tag: 0)
        firstTabBarController.tabBarItem = item1

        mainViewController = mainViewContoller
        let presenter = MainViewControllerPresenter(viewController: mainViewContoller)
        mainViewControllerInteractor = MainViewControllerInteractor(presenter: presenter)
        mainViewControllerPresenter = presenter
    }
}
