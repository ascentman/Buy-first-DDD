//
//  Animator.swift
//  Buy first DDD
//
//  Created by user on 6/29/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

final class Animator {
    private let animation: Animation

    init(animation: @escaping Animation) {
        self.animation = animation
    }

    func animate(tableView: UITableView) {

        animation(tableView)
    }
}
