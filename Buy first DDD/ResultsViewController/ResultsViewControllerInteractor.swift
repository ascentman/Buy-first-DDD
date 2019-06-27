//
//  ResultsViewControllerInteractor.swift
//  Buy first DDD
//
//  Created by user on 6/24/19.
//  Copyright © 2019 user. All rights reserved.
//

import Foundation

final class ResultsViewControllerInteractor {

    let currentFilter: Filter
    private weak var resultsViewController: ResultsViewController?

    init(resultsViewController: ResultsViewController, filter: Filter) {
        self.resultsViewController = resultsViewController
        self.currentFilter = filter

        generateNetworkRequest()

        resultsViewController.onGenerateRequest = { [weak self] in
            self?.generateNetworkRequest()
        }
    }

    // MARK: - Private

    private func generateNetworkRequest() {
        if currentFilter.itemToSearch.isEmpty {
            return
        }

        guard let itemName = currentFilter.itemToSearch.trim().addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            !itemName.isEmpty else {
            return
        }

        guard let min = Int(currentFilter.minPrice),
            let max = Int(currentFilter.maxPrice),
            max >= min else {
                return
        }
        var baseAbsoluteUrl = "https://www.ebay.com/sch/i.html?_from=R40&_nkw=\(itemName)&_sacat=0&_sop=10&_udlo=\(currentFilter.minPrice)&_udhi=\(currentFilter.maxPrice)"
        switch currentFilter.selectedCondition {
        case .new:
            baseAbsoluteUrl.append("&LH_ItemCondition=1000")
        case .openBox:
            baseAbsoluteUrl.append("&LH_ItemCondition=1500")
        case .manufactureRefurbished:
            baseAbsoluteUrl.append("&LH_ItemCondition=2000")
        case .sellerRefurbished:
            baseAbsoluteUrl.append("&LH_ItemCondition=2500")
        case .used:
            baseAbsoluteUrl.append("&LH_ItemCondition=3000")
        case .forParts:
            baseAbsoluteUrl.append("&LH_ItemCondition=7000")
        default:
            break
        }

        if currentFilter.rows[0].isSelected {
            baseAbsoluteUrl.append("&LH_Auction=1")
        } else if currentFilter.rows[1].isSelected {
            baseAbsoluteUrl.append("&LH_BIN=1")
        } else if currentFilter.rows[3].isSelected {
            baseAbsoluteUrl.append("&LH_FS=1")
        }

        resultsViewController?.webView.loadUrl(string: baseAbsoluteUrl)
    }
}

// Extensions

extension String {
    func trim() -> String {
        return trimmingCharacters(in: CharacterSet.whitespaces)
    }
}
