//
//  AppDelegate.swift
//  MartHoliday
//
//  Created by YOUTH2 on 2018. 8. 10..
//  Copyright © 2018년 JINiOS. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications
import Reachability

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {

    var window: UIWindow?
    var networkManager: NetworkManager?
    let gcmMessageIDKey = "gcm.message_id"
    private let appGroup = UserDefaults.init(suiteName: "group.martHoliday.com")

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window?.backgroundColor = .white
        // listener starts
        networkManager = NetworkManager.shared

        setNavigationBar()
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        application.applicationIconBadgeNumber = 0

        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: { granted, error in
            })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()

        guard let loadedData = DataStorage<FavoriteList>.load() else { return true }
        FavoriteList.loadSavedData(loadedData)
        setFavoritesURLTodayExtension()

        NotificationCenter.default.addObserver(self, selector: #selector(subscribe(notification:)), name: .changeSubscribe, object: nil)
        return true
    }

    // [START refresh_token]
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        FavoriteAPI.shared.configure(token: fcmToken)
    }

    // MARK: Life Cycle functions

    func applicationDidEnterBackground(_ application: UIApplication) {
        DataStorage<FavoriteList>.save(data: FavoriteList.shared())
        setFavoritesURLTodayExtension()
        FavoriteAPI.shared.save()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        guard let loadedData = DataStorage<FavoriteList>.load() else { return }
        // background상태로 가면서 저장했던 인스턴스로 대체해주는데, background로 가면서 저장했던 데이터와 같으면 대체를안하고 다르면 새 데이터로 대체함
        if !FavoriteList.isSameData(loadedData) {
            FavoriteList.loadSavedData(loadedData)
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        DataStorage<FavoriteList>.save(data: FavoriteList.shared())
        setFavoritesURLTodayExtension()
        FavoriteAPI.shared.save()
    }

    // MARK: Private & @objc functions

    private func setFavoritesURLTodayExtension() {
        guard let value = KeyInfoLoader.loadValue(of: .FavoriteBranchesURL) else { return }
        appGroup?.setValue(value, forKey: KeyInfo.FavoriteBranchesURL.rawValue)
        appGroup?.setValue(FavoriteList.shared().ids(), forKey: "favorites")
    }

    private func setNavigationBar() {
        let fontAttributes = [
            NSAttributedStringKey.foregroundColor: UIColor.white,
            NSAttributedStringKey.font: UIFont(name: "NanumSquareRoundOTF", size: UIFont.labelFontSize)?.bold()
        ]

        //To change Navigation Bar Background Color
        UINavigationBar.appearance().barTintColor = UIColor.appColor(color: .mint)
        //To change Back button title & icon color
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = fontAttributes
        UIBarButtonItem.appearance().setTitleTextAttributes(fontAttributes, for: .normal)
    }

    @objc func subscribe(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let subscribeType = userInfo["subscribeType"] else { return }
        guard let subscribe = subscribeType as? Bool else { return }
        guard let idValue = userInfo["id"] else { return }
        guard let id = idValue as? Int else { return }

        if subscribe {
            Messaging.messaging().subscribe(toTopic: "\(id)")
        } else {
            Messaging.messaging().unsubscribe(fromTopic: "\(id)")
        }
    }

}

