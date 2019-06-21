//
//  MainViewControllerPresenter.swift
//  Buy first DDD
//
//  Created by user on 6/20/19.
//  Copyright © 2019 user. All rights reserved.
//

import Foundation

final class MainViewControllerPresenter {

    private let mainViewController: MainTableViewController

    var didSelectAuction: () -> Void = { assertionFailure() }
    var didSelectBuyItNow: () -> Void = { assertionFailure() }
    var didSelectAnyShipping: () -> Void = { assertionFailure() }
    var didSelectFreeShipping: () -> Void = { assertionFailure() }
    var didSelectCondition: (Condition) -> Void = { _ in assertionFailure() }

    init(viewController: MainTableViewController) {
        self.mainViewController = viewController
    }

    func present(filter: Filter) {
        let auctionCheckMark = Checkmark(isChecked: filter.rows[0].isSelected) { [weak self] in
            self?.didSelectAuction()
        }
        let buyItNowCheckMark = Checkmark(isChecked: filter.rows[1].isSelected) { [weak self] in
            self?.didSelectBuyItNow()
        }
        let anyShippingCheckMark = Checkmark(isChecked: filter.rows[2].isSelected) { [weak self] in
            self?.didSelectAnyShipping()
        }
        let freeShippingCheckMark = Checkmark(isChecked: filter.rows[3].isSelected) { [weak self] in
            self?.didSelectFreeShipping()
        }

        mainViewController.render(props: MainTableViewController.Props(title: filter.title,
                                                                       auctionCheckMark: auctionCheckMark,
                                                                       buyItNowCheckMark: buyItNowCheckMark,
                                                                       anyShippingCheckmark: anyShippingCheckMark,
                                                                       freeShippingCheckmark: freeShippingCheckMark,
                                                                       selectedCondition: filter.selectedCondition,
                                                                       onUpdateCondition: { [weak self] condition in
                                                                        self?.didSelectCondition(condition) }
        ))
    }
}
