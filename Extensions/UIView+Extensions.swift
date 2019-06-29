//
//  UIView+Extensions.swift
//  Buy first DDD
//
//  Created by user on 6/29/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

extension UIView {
    func shake() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.05
        animation.repeatCount = 5
        animation.autoreverses = true
        animation.fromValue = CGPoint(x: self.center.x - 4.0, y: self.center.y)
        animation.toValue = CGPoint(x: self.center.x + 4.0, y: self.center.y)
        layer.add(animation, forKey: "position")
    }

    func pulse(completion: @escaping () -> ()) {
        let animation = CASpringAnimation(keyPath: "transform.scale")
        animation.duration = 0.3
        animation.fromValue = 0.95
        animation.toValue = 1.0
        animation.repeatCount = 1
        animation.initialVelocity = 0.5
        layer.add(animation, forKey: nil)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            completion()
        }
    }
}
