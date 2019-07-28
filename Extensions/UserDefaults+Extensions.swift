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
    static let removeAd = "removeAd"
    static let searchesCount = "searchesCount"
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

    var removeAd: Bool {
        get {
            return UserDefaults.standard.bool(forKey: Constants.removeAd)
        }
    }

    var searchesCount: Int {
        get {
            return UserDefaults.standard.integer(forKey: Constants.searchesCount)
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

    func isSearchesCountPresentInUserDefaults() -> Bool {
        return UserDefaults.standard.object(forKey: Constants.searchesCount) != nil
    }

    func isRemoveAdsInUserDefaults() -> Bool {
        return UserDefaults.standard.object(forKey: Constants.removeAd) != nil
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

    func updateHidingAds(_ value: Bool) {
        UserDefaults.standard.set(value, forKey: Constants.removeAd)
    }

    func increaseSearchesCountBy(_ value: Int) {
        let newValue = searchesCount + value
        UserDefaults.standard.set(newValue, forKey: Constants.searchesCount)
    }

    func decreaseSearchesCount() {
        let newValue = searchesCount - 1
        UserDefaults.standard.set(newValue, forKey: Constants.searchesCount)
    }

    func setDefaultSearchesCount() {
        UserDefaults.standard.set(3, forKey: Constants.searchesCount)
    }
}
