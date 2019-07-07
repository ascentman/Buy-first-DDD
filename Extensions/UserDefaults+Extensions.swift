//
//  UserDefaults+Extensions.swift
//  Buy first DDD
//
//  Created by user on 7/7/19.
//  Copyright © 2019 user. All rights reserved.
//

import Foundation

private enum Constants {
    static let itemsCount = "itemsCount"
    static let reloadTimeInterval = "reloadTimeInterval"
    static let continuousReload = "continuousReload"
}

extension UserDefaults {

    var itemsCount: Int {
        get {
            return UserDefaults.standard.integer(forKey: Constants.itemsCount)
        }
    }

    var reloadTimeInterval: Int {
        get {
            return UserDefaults.standard.integer(forKey: Constants.reloadTimeInterval)
        }
    }

    var continuousReload: Bool {
        get {
            return UserDefaults.standard.bool(forKey: Constants.continuousReload)
        }
    }

    func isItemsCountPresentInUserDefaults() -> Bool {
        return UserDefaults.standard.object(forKey: Constants.itemsCount) != nil
    }

    func isItemsReloadTimeIntervalPresentInUserDefaults() -> Bool {
        return UserDefaults.standard.object(forKey: Constants.reloadTimeInterval) != nil
    }

    func isItemsContinuousReloadPresentInUserDefaults() -> Bool {
        return UserDefaults.standard.object(forKey: Constants.continuousReload) != nil
    }

    func updateItemsCount(_ value: Int) {
        UserDefaults.standard.set(value, forKey: Constants.itemsCount)
    }

    func updateReloadTimeInterval(_ value: Int) {
        UserDefaults.standard.set(value, forKey: Constants.reloadTimeInterval)
    }

    func updateContinuousReload(_ value: Bool) {
        UserDefaults.standard.set(value, forKey: Constants.continuousReload)
    }
}
