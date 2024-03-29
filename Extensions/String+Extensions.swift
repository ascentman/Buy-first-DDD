//
//  String+Extensions.swift
//  Buy first DDD
//
//  Created by user on 6/29/19.
//  Copyright © 2019 user. All rights reserved.
//

import Foundation

extension String {
    func trim() -> String {
        return trimmingCharacters(in: CharacterSet.whitespaces)
    }

    var isAlphanumericWithSpace: Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9 ]", options: .regularExpression) == nil
    }
}
