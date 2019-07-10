//
//  Router.swift
//  Buy first DDD
//
//  Created by user on 6/20/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

final class Router {

    private let tabBarController = CustomTabBarController()
    private let searchNavController = CustomNavigationController()
    private let optionsNavController = CustomNavigationController()

    init() {
        tabBarController.viewControllers = [searchNavController, optionsNavController]
        searchNavController.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.purple,
             NSAttributedString.Key.font: UIFont(name: "ChalkboardSE-Bold", size: 19.0)!]
        optionsNavController.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.purple,
             NSAttributedString.Key.font: UIFont(name: "ChalkboardSE-Bold", size: 19.0)!]

        let backImage = UIImage(named: "back")
        UINavigationBar.appearance().backIndicatorImage = backImage
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = backImage
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor:
            UIColor.clear], for: .normal)
        UIBarButtonItem.appearance().tintColor = UIColor.orange
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: 0, vertical: -5), for: .default)

        routeToOptionsTableViewController()

        // tabBar items
        let item1 = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        let item2 = UITabBarItem(title: "Settings", image: UIImage(named: "settings"), tag: 1)
        searchNavController.tabBarItem = item1
        optionsNavController.tabBarItem = item2
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
        searchNavController.pushViewController(mainViewController, animated: false)
    }

    func routeToResultsViewController(filter: Filter) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let resultsViewContoller = storyboard.instantiateViewController(withIdentifier: "ResultsViewController") as? ResultsViewController else {
            return
        }
        let resultViewControllerInteractor = ResultsViewControllerInteractor(resultsViewController: resultsViewContoller, filter: filter)
        resultsViewContoller.retainedObject = [resultViewControllerInteractor] as AnyObject
        searchNavController.pushViewController(resultsViewContoller, animated: false)
    }

    func routeToOptionsTableViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let optionsTableViewController = storyboard.instantiateViewController(withIdentifier: "OptionsTableViewController") as? OptionsTableViewController else {
            return
        }

        optionsNavController.pushViewController(optionsTableViewController, animated: false)
    }
}
