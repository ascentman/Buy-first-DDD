//
//  Router.swift
//  Buy first DDD
//
//  Created by user on 6/20/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

final class Router {

    private let navController = CustomNavigationController()

    init() {
        let backImage = UIImage(named: "back")
        UINavigationBar.appearance().backIndicatorImage = backImage
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = backImage
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor:
            UIColor.clear], for: .normal)
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor:
            UIColor.clear], for: .highlighted)
        UIBarButtonItem.appearance().tintColor = UIColor.orange
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: 0, vertical: -5), for: .default)

        navController.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.purple,
             NSAttributedString.Key.font: UIFont(name: "ChalkboardSE-Bold", size: 19.0)!]

    }

    var rootViewController: UIViewController {
        return navController
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

        navController.pushViewController(startViewController, animated: false)

        let presenter = StartViewControllerPresenter(viewController: startViewController)
        let startViewControllerInteractor = StartViewControllerInteractor(presenter: presenter, onSearchRequested: { [weak self] name in
            self?.routeToMainViewController(name)
        })

        startViewController.retainedObject = [presenter, startViewControllerInteractor] as AnyObject
        startViewControllerInteractor.start()
    }

    func routeToMainViewController(_ name: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let mainViewController = storyboard.instantiateViewController(withIdentifier: "MainTableViewController") as? MainTableViewController,
        let optionsTableViewController = storyboard.instantiateViewController(withIdentifier: "OptionsTableViewController") as? OptionsTableViewController else {
            return
        }

        let presenter = MainViewControllerPresenter(viewController: mainViewController)
        let mainViewControllerInteractor = MainViewControllerInteractor(presenter: presenter, onSearchRequested: { [weak self] filter in
            self?.routeToResultsViewController(filter: filter)
        })

        mainViewController.retainedObject = [presenter, mainViewControllerInteractor] as AnyObject
        mainViewControllerInteractor.start(name)

        // tabBar
        let tabBarController = CustomTabBarController()
        tabBarController.viewControllers = [mainViewController, optionsTableViewController]

        // tabBar items
        let item1 = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        let item2 = UITabBarItem(title: "Settings", image: UIImage(named: "settings"), tag: 1)
        mainViewController.tabBarItem = item1
        optionsTableViewController.tabBarItem = item2
        navController.pushViewController(tabBarController, animated: false)
    }

    func routeToResultsViewController(filter: Filter) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let resultsViewContoller = storyboard.instantiateViewController(withIdentifier: "ResultsViewController") as? ResultsViewController else {
            return
        }
        let resultViewControllerInteractor = ResultsViewControllerInteractor(resultsViewController: resultsViewContoller, filter: filter)
        resultsViewContoller.retainedObject = [resultViewControllerInteractor] as AnyObject
        navController.pushViewController(resultsViewContoller, animated: false)
    }
}
