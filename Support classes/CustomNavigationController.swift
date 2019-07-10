//
//  CustomNavigationController.swift
//  Buy first DDD
//
//  Created by user on 7/10/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

final class CustomNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self
    }

    private func addAnimatedLayer() {
        let transition: CATransition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.fade
        view.layer.add(transition, forKey: nil)
    }
}

extension CustomNavigationController: UINavigationControllerDelegate {

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        addAnimatedLayer()
        super.pushViewController(viewController, animated: false)
    }

    override func popViewController(animated: Bool) -> UIViewController? {
        addAnimatedLayer()
        return super.popViewController(animated: false)
    }
}
