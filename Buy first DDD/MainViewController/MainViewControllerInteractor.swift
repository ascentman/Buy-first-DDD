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
    var minPrice: String
    var maxPrice: String
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

    init(presenter: MainViewControllerPresenter, onSearchRequested: @escaping (Filter) -> Void) {
        self.presenter = presenter

        self.presenter.didSelectAuction = { [weak self] in
            self?.updateFilterCriteria(itemRow: 0)
        }

        self.presenter.didSelectBuyItNow = { [weak self] in
            self?.updateFilterCriteria(itemRow: 1)
        }

        self.presenter.didSelectAnyShipping = { [weak self] in
            self?.updateFilterCriteria(itemRow: 2)
        }

        self.presenter.didSelectFreeShipping = { [weak self] in
            self?.updateFilterCriteria(itemRow: 3)
        }

        self.presenter.didSelectCondition = { [weak self] condition in
            self?.currentFilter?.selectedCondition = condition
        }

        self.presenter.onSearchPressed = { [weak self] in
            guard let filter = self?.currentFilter else {
                return
            }
            onSearchRequested(filter)
        }
    }

    func start() {

        let auctionRow = Filter.Row(title: "Auction", isSelected: true)
        let buyItNowRow = Filter.Row(title: "Buy it now", isSelected: false)
        let anyShippingRow = Filter.Row(title: "Any", isSelected: true)
        let freeShippingRow = Filter.Row(title: "Auction", isSelected: false)

        self.currentFilter = Filter(title: "Search", selectedCondition: .any, minPrice: "100", maxPrice: "200", rows: [auctionRow, buyItNowRow, anyShippingRow, freeShippingRow])
    }

    // MARK: - Private

    private func updateFilterCriteria(itemRow: Int) {
        guard var filter = self.currentFilter else {
            assertionFailure()
            return
        }
        var row = filter.rows[itemRow]
        row.isSelected = !row.isSelected
        filter.rows[itemRow] = row
        self.currentFilter = filter
    }
}
