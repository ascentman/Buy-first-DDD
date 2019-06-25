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
    }

    // MARK: - Private

    private func generateNetworkRequest() {
        let baseAbsoluteUrl = "https://www.ebay.com/sch/i.html?_from=R40&_nkw=\(currentFilter.itemToSearch)&_sacat=0&_sop=10&_udlo=\(currentFilter.minPrice)&_udhi=\(currentFilter.maxPrice)"
        guard let url = URL(string: baseAbsoluteUrl) else {
            return
        }

        let request = URLRequest(url: url)
        resultsViewController?.webView.load(request)
    }
}
