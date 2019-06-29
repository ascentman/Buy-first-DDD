//
//  UINavigationController+Extensions.swift
//  Buy first DDD
//
//  Created by user on 6/29/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

extension UINavigationController {
    func fadeTo(_ viewController: UIViewController) {
        let transition: CATransition = CATransition()
        transition.duration = 0.4
        transition.type = CATransitionType.fade
        view.layer.add(transition, forKey: nil)
        pushViewController(viewController, animated: false)
    }
}
