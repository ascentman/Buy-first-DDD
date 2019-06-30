//
//  LocalNotificationService.swift
//  SwiftScraper
//
//  Created by user on 6/18/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit
import UserNotifications

final class LocalNotificationsService: NSObject {

    static let shared = LocalNotificationsService()
    private let center = UNUserNotificationCenter.current()
    private override init() {}

    func registerLocalNotifications() {
        center.delegate = self
        UIApplication.shared.applicationIconBadgeNumber = 0
        center.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if granted {
                self.registerCategory()
                //                if UserDefaults().isNotificationsTurnedOn {
//                self.sendNotification()
                //                }
            }
        }
    }

    func sendNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Buy First Notification"
        content.subtitle = "New items founded"
        content.body = "I am annoying notification😜"
        content.badge = 1
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = "actionCategory"
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.7, repeats: false)
        let requestIdentifier = "CardGuruNotification"
        let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
        center.add(request, withCompletionHandler: { (error) in
            assert(error == nil, "error: request failed")
        })
    }

    func registerCategory() {
        let dismissAction = UNNotificationAction(identifier: "dismiss", title: "Dismiss", options: [])
        let category = UNNotificationCategory(identifier: "actionCategory",
                                              actions: [dismissAction],
                                              intentIdentifiers: [], options: [])
        center.setNotificationCategories([category])
    }
}

extension LocalNotificationsService: UNUserNotificationCenterDelegate {

    // MARK: - UNUserNotificationCenterDelegate

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound, .badge])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        switch response.actionIdentifier {
        case "dismiss":
            UIApplication.shared.applicationIconBadgeNumber -= 1
        default:
            break
        }
        completionHandler()
    }
}
