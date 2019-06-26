//
//  EbayResponse.swift
//  Buy first DDD
//
//  Created by user on 6/26/19.
//  Copyright © 2019 user. All rights reserved.
//

import Foundation
import SwiftSoup

private enum HTMLError: Error {
    case badResponse
}

final class EbayResponse {

    var items: [Item] = []
    var totalResults: String = "0"

    init(_ innerHTML: Any?) throws {
        guard let htmlString = innerHTML as? String else {
            throw HTMLError.badResponse
        }
        let document = try SwiftSoup.parse(htmlString)
        //        print(document)

        let totalCount = try document.getElementsByClass("srp-controls__count-heading").text()
        totalResults = totalCount

        let itemTitles = try document.getElementsByClass("s-item__title").array()
        let itemPrices = try document.getElementsByClass("s-item__price").array()
        let itemImages = try document.getElementsByClass("s-item__image-img").array()
        let itemLink = try document.getElementsByClass("s-item__link").array()

        for i in 3..<13 {
            let item = Item(name: try itemTitles[i + 1].text(), price: try itemPrices[i].text(), imageAbsolutePath: try itemImages[i].attr("src"), detailsLink: try itemLink[i].attr("href"))
            items.append(item)
        }
    }
}
