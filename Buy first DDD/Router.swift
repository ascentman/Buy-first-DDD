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
    private let searchNavController = UINavigationController()
    private let bookmarksNavController = UINavigationController()

    init() {
        tabBarController.viewControllers = [searchNavController, bookmarksNavController]

        // tabBar items
        let item1 = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        searchNavController.tabBarItem = item1
    }

    var rootViewController: UIViewController {
        return tabBarController
    }

    // MARK: - Public

    func start() {
        self.showMainViewController()
    }

    private func showMainViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let mainViewController = storyboard.instantiateViewController(withIdentifier: "MainTableViewController") as? MainTableViewController else {
            return
        }

        searchNavController.pushViewController(mainViewController, animated: false)

        let presenter = MainViewControllerPresenter(viewController: mainViewController, onSearchPressed: { [weak self] in
            self?.routeToResultsViewController()
        })
        let mainViewControllerInteractor = MainViewControllerInteractor(presenter: presenter)

        mainViewController.retainedObject = [presenter, mainViewControllerInteractor] as AnyObject
        mainViewControllerInteractor.start()
    }

    func routeToResultsViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let resultsViewContoller = storyboard.instantiateViewController(withIdentifier: "ResultsViewController") as? ResultsViewController else {
            return
        }

        searchNavController.pushViewController(resultsViewContoller, animated: true)
    }
}
