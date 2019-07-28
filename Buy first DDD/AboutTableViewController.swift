//
//  AboutTableViewController.swift
//  Buy first DDD
//
//  Created by user on 7/23/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit
import StoreKit

private enum Row: Int {
    case none
    case removeAds
    case unknown

    init(indexPath: IndexPath) {
        var row = Row.unknown

        switch (indexPath.section, indexPath.row) {
        case (0, 3):
            row = Row.removeAds
        default:
            break
        }
        self = row
    }
}


final class AboutTableViewController: UITableViewController {

    @IBOutlet private weak var seaches30Button: UIButton!
    @IBOutlet private weak var searches100Button: UIButton!
    @IBOutlet private weak var remvoeAdsButton: UIButton!

    private var products: [SKProduct] = []
    private var removeAdsIsHidden = false

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        BuyProducts.store.requestProducts { [weak self] success, products in
            if success {
                self?.products = products!
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tabBarController?.title = "About"
        if BuyProducts.store.isProductPurchased(BuyProducts.removeAds) {
            removeAdsHide()
            tableView.reloadData()
            tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        }
    }

    // MARK: - Actions

    @IBAction func searches30DidPressed(_ sender: Any) {
        buyProductBy(id: BuyProducts.buy30searches)
    }
    @IBAction func searches100DidPressed(_ sender: Any) {
        buyProductBy(id: BuyProducts.buy100searches)
    }
    @IBAction func removeAdsDidPressed(_ sender: Any) {
        buyProductBy(id: BuyProducts.removeAds)
        removeAdsHide()
    }
    @IBAction func restorePurchasesDidPressed(_ sender: Any) {
        BuyProducts.store.restorePurchases()
    }

    // MARK: - UITableViewDelegate

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let row = Row(indexPath: indexPath)
        var rowHeight: CGFloat = super.tableView(tableView, heightForRowAt: indexPath)
        switch row {
        case .removeAds:
            rowHeight = removeAdsIsHidden ? 0 : super.tableView(tableView, heightForRowAt: indexPath)
        default:
            break
        }
        return rowHeight
    }

    // MARK: - Private

    private func buyProductBy(id: String) {
        let product = products.filter { id == $0.productIdentifier }.first
        guard let productToBuy = product else {
            print("can't buy it")
            return
        }
        BuyProducts.store.buyProduct(productToBuy)
    }

    private func removeAdsHide() {
        removeAdsIsHidden = true
        UserDefaults.standard.updateHidingAds(true)
    }
}
