//
//  AppDelegate.swift
//  Buy first DDD
//
//  Created by user on 6/20/19.
//  Copyright © 2019 user. All rights reserved.

import UIKit
import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private let router = Router()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        application.isIdleTimerDisabled = true
        UIApplication.shared.applicationIconBadgeNumber = 0
        window = UIWindow(frame: UIScreen.main.bounds)
        setupWindowLayout()
        router.start()
        window?.rootViewController = router.rootViewController
        window?.makeKeyAndVisible()

        GADMobileAds.sharedInstance().start(completionHandler: nil)
        return true
    }

    // MARK: - Private

    private func setupWindowLayout() {
        window?.tintColor = .orange
    }
}
