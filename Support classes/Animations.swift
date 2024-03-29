//
//  Animations.swift
//  Buy first DDD
//
//  Created by user on 6/29/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

typealias Animation = (UITableView) -> Void

enum AnimationFactory {

    static func makeMoveUpWithBounce(rowHeight: CGFloat, duration: TimeInterval, delayFactor: Double) -> Animation {
        return { tableView in

            for (index, cell) in tableView.visibleCells.enumerated() {
                cell.transform = CGAffineTransform(translationX: 0, y: rowHeight / 2)
                UIView.animate(
                    withDuration: duration,
                    delay: delayFactor * Double(index),
                    usingSpringWithDamping: 0.9,
                    initialSpringVelocity: 0.1,
                    options: [.curveEaseInOut],
                    animations: {
                        cell.transform = CGAffineTransform(translationX: 0, y: 0)
                })
            }
        }
    }

    static func makeSlideIn(duration: TimeInterval, delayFactor: Double) -> Animation {
        return { tableView in
            for (index, cell) in tableView.visibleCells.enumerated() {
                cell.transform = CGAffineTransform(translationX: tableView.bounds.width, y: 0)
                UIView.animate(
                    withDuration: duration,
                    delay: delayFactor * Double(index),
                    options: [.curveEaseInOut],
                    animations: {
                        cell.transform = CGAffineTransform(translationX: 0, y: 0)
                })
            }
        }
    }
}
