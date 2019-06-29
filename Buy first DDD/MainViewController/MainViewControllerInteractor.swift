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
    var itemToSearch: String
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
    private var itemToSearch: String = ""
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
            self?.updateFilterCriteria(itemRow: 0, uncheckRow: nil)
        }

        self.presenter.didSelectBuyItNow = { [weak self] in
            self?.updateFilterCriteria(itemRow: 1, uncheckRow: nil)
        }

        self.presenter.didSelectAnyShipping = { [weak self] in
            self?.updateFilterCriteria(itemRow: 2, uncheckRow: 3)
        }

        self.presenter.didSelectFreeShipping = { [weak self] in
            self?.updateFilterCriteria(itemRow: 3, uncheckRow: 2)
        }

        self.presenter.didSelectCondition = { [weak self] condition in
            self?.currentFilter?.selectedCondition = condition
        }

        self.presenter.onSearchPressed = { [weak self] (minPrice, maxPrice) in
            self?.currentFilter?.itemToSearch = self?.itemToSearch ?? ""
            self?.currentFilter?.minPrice = minPrice
            self?.currentFilter?.maxPrice = maxPrice
            guard let filter = self?.currentFilter else {
                return
            }
            onSearchRequested(filter)
        }
    }

    func start(_ name: String) {

        itemToSearch = name
        let auctionRow = Filter.Row(title: "Auction", isSelected: true)
        let buyItNowRow = Filter.Row(title: "Buy it now", isSelected: false)
        let anyShippingRow = Filter.Row(title: "Any shipping", isSelected: true)
        let freeShippingRow = Filter.Row(title: "Free shipping", isSelected: false)

        self.currentFilter = Filter(title: "Apply filters", itemToSearch: itemToSearch, selectedCondition: .any, minPrice: "0", maxPrice: "9999", rows: [auctionRow, buyItNowRow, anyShippingRow, freeShippingRow])
    }

    // MARK: - Private

    private func updateFilterCriteria(itemRow: Int, uncheckRow: Int?) {
        guard var filter = self.currentFilter else {
            assertionFailure()
            return
        }
        var row = filter.rows[itemRow]
        row.isSelected = !row.isSelected
        filter.rows[itemRow] = row
        if let uncheckRow = uncheckRow {
            var uncheckedRow = filter.rows[uncheckRow]
            uncheckedRow.isSelected = !uncheckedRow.isSelected
            filter.rows[uncheckRow] = uncheckedRow
        }
        self.currentFilter = filter
    }
}
