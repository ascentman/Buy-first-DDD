//
//  MainViewControllerInteractor.swift
//  Buy first DDD
//
//  Created by user on 6/20/19.
//  Copyright © 2019 user. All rights reserved.
//

import Foundation

struct Filter {
    let title: String
    var selectedCondition: Condition
    var rows: [Row]
    struct Row {
        let title: String
        var isSelected: Bool
    }
}

final class MainViewControllerInteractor {

    private let presenter: MainViewControllerPresenter
    private var currentFilter: Filter? {
        didSet {
            if let newFilter = currentFilter {
                presenter.present(filter: newFilter)
            }
        }
    }

    init(presenter: MainViewControllerPresenter) {
        self.presenter = presenter

        self.presenter.didSelectAuction = { [weak self] in
            guard var filter = self?.currentFilter else {
                assertionFailure()
                return
            }
            var row = filter.rows[0]
            row.isSelected = !row.isSelected

            filter.rows[0] = row

            self?.currentFilter = filter
        }

        self.presenter.didSelectBuyItNow = { [weak self] in
            guard var filter = self?.currentFilter else {
                assertionFailure()
                return
            }
            var row = filter.rows[1]
            row.isSelected = !row.isSelected
            filter.rows[1] = row
            self?.currentFilter = filter
        }

        self.presenter.didSelectAnyShipping = { [weak self] in
            guard var filter = self?.currentFilter else {
                assertionFailure()
                return
            }
            var row = filter.rows[2]
            row.isSelected = !row.isSelected
            filter.rows[2] = row
            self?.currentFilter = filter
        }

        self.presenter.didSelectFreeShipping = { [weak self] in
            guard var filter = self?.currentFilter else {
                assertionFailure()
                return
            }
            var row = filter.rows[3]
            row.isSelected = !row.isSelected
            filter.rows[3] = row
            self?.currentFilter = filter
        }

        self.presenter.didSelectCondition = { [weak self] condition in
            self?.currentFilter?.selectedCondition = condition
        }
    }

    func start() {

        let auctionRow = Filter.Row(title: "Auction", isSelected: true)
        let buyItNowRow = Filter.Row(title: "Buy it now", isSelected: false)
        let anyShippingRow = Filter.Row(title: "Any", isSelected: true)
        let freeShippingRow = Filter.Row(title: "Auction", isSelected: false)

        self.currentFilter = Filter(title: "Search", selectedCondition: .any, rows: [auctionRow, buyItNowRow, anyShippingRow, freeShippingRow])
    }
}
