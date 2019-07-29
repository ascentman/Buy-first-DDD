//
//  Item.swift
//  Buy first DDD
//
//  Created by user on 6/26/19.
//  Copyright © 2019 user. All rights reserved.
//

import Foundation

final class Item {
    let name: String
    let price: String
    let imageAbsolutePath: String
    let detailsLink: String

    init(name: String, price: String, imageAbsolutePath: String, detailsLink: String) {
        self.name = name
        self.price = price
        self.imageAbsolutePath = imageAbsolutePath
        self.detailsLink = detailsLink
    }
}

extension Item: Equatable {
    static func == (lhs: Item, rhs: Item) -> Bool {
        return lhs.name == rhs.name &&
            lhs.price == rhs.price &&
            lhs.imageAbsolutePath == rhs.imageAbsolutePath &&
            lhs.detailsLink == rhs.detailsLink
    }
}
