//
//  CustomTabBarController.swift
//  Buy first DDD
//
//  Created by user on 7/10/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

final class CustomTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self
    }
}

extension CustomTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {

        guard let fromView = selectedViewController?.view, let toView = viewController.view else {
            return false
        }

        if fromView != toView {
            UIView.transition(from: fromView, to: toView, duration: 0.3, options: [.transitionCrossDissolve], completion: nil)
        }
        return true
    }
}
