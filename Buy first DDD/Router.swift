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
//        UITabBar.appearance().shadowImage = UIImage()
//        UITabBar.appearance().backgroundImage = UIImage()
//        UITabBar.appearance().barTintColor = UIColor.clear
//        tabBarController.viewControllers = [searchNavController, bookmarksNavController]
//
//        searchNavController.navigationBar.shadowImage = UIImage()
//        searchNavController.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)

        // tabBar items
        let item1 = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        searchNavController.tabBarItem = item1
    }

    var rootViewController: UIViewController {
        return tabBarController
    }

    // MARK: - Public

    func start() {
        self.showStartViewController()
    }

    private func showStartViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let startViewController = storyboard.instantiateViewController(withIdentifier: "StartViewController") as? StartViewController else {
            return
        }

        searchNavController.pushViewController(startViewController, animated: false)

        let presenter = StartViewControllerPresenter(viewController: startViewController)
        let startViewControllerInteractor = StartViewControllerInteractor(presenter: presenter, onSearchRequested: { [weak self] name in
            self?.routeToMainViewController(name)
        })

        startViewController.retainedObject = [presenter, startViewControllerInteractor] as AnyObject
        startViewControllerInteractor.start()
    }

    func routeToMainViewController(_ name: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let mainViewController = storyboard.instantiateViewController(withIdentifier: "MainTableViewController") as? MainTableViewController else {
            return
        }

        let presenter = MainViewControllerPresenter(viewController: mainViewController)
        let mainViewControllerInteractor = MainViewControllerInteractor(presenter: presenter, onSearchRequested: { [weak self] filter in
            self?.routeToResultsViewController(filter: filter)
        })

        mainViewController.retainedObject = [presenter, mainViewControllerInteractor] as AnyObject
        mainViewControllerInteractor.start(name)
        searchNavController.fadeTo(mainViewController)
    }

    func routeToResultsViewController(filter: Filter) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let resultsViewContoller = storyboard.instantiateViewController(withIdentifier: "ResultsViewController") as? ResultsViewController else {
            return
        }
        let resultViewControllerInteractor = ResultsViewControllerInteractor(resultsViewController: resultsViewContoller, filter: filter)
        resultsViewContoller.retainedObject = [resultViewControllerInteractor] as AnyObject
        searchNavController.pushViewController(resultsViewContoller, animated: true)
    }
}
