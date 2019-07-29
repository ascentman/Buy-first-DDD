//
//  BuyProducts.swift
//  Buy first DDD
//
//  Created by user on 7/27/19.
//  Copyright © 2019 user. All rights reserved.
//

import Foundation

struct BuyProducts {

    static let removeAds = "volodymyr.rykhva.QuickieRicky.removeAds"
    static let buy30searches = "volodymyr.rykhva.QuickieRicky_30searches"
    static let buy100searches = "volodymyr.rykhva.QuickieRicky_100searches"

    private static let productIdentifiers: Set<ProductIdentifier> = [BuyProducts.removeAds, BuyProducts.buy30searches, BuyProducts.buy100searches]

    static let store = IAPHelper(productIds: BuyProducts.productIdentifiers)
}

func resourceNameForProductIdentifier(_ productIdentifier: String) -> String? {
    return productIdentifier.components(separatedBy: ".").last
}
