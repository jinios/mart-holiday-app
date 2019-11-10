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
import NMapsMap

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {

    var window: UIWindow?
    var networkManager: NetworkManager?
    let gcmMessageIDKey = "gcm.message_id"
    private let appGroup = UserDefaults.init(suiteName: "group.martHoliday.com")
    private var isPushAllowed: Bool?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        FirebaseApp.configure()

        window?.backgroundColor = .white
        window?.rootViewController = UIStoryboard.init(name: "LaunchScreen", bundle: nil).instantiateInitialViewController()
        RemoteConfigManager.shared().launch(handler: self.executeAppUpdate)

        // listener starts
        networkManager = NetworkManager.shared

        setNavigationBar()
        setNMFMapViewKey()

        application.applicationIconBadgeNumber = 0

        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: { granted, error in
                    self.isPushAllowed = granted
            })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }

        Messaging.messaging().delegate = self
        application.registerForRemoteNotifications()

        guard let loadedData = DataStorage<FavoriteList>.load() else { return true }
        FavoriteList.loadSavedData(loadedData)
        setFavoritesURLTodayExtension()
        return true
    }


    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        if notificationSettings.types == .none {
            self.isPushAllowed = false
        } else {
            self.isPushAllowed = true
        }
    }

    // [START refresh_token]
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        FavoriteAPI.shared.configure(token: fcmToken, isPushAllowed: self.isPushAllowed)
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

    func applicationWillResignActive(_ application: UIApplication) {
        DataStorage<FavoriteList>.save(data: FavoriteList.shared())
        setFavoritesURLTodayExtension()
        FavoriteAPI.shared.save()
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

        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.appColor(color: .mint)

            appearance.largeTitleTextAttributes = [.font: UIFont(name: "NanumSquareRoundOTF", size: 24)?.bold() ?? UIFont(),
            .foregroundColor: UIColor.white]
            appearance.titleTextAttributes = [.font: UIFont(name: "NanumSquareRoundOTF", size: UIFont.labelFontSize)?.bold() ?? UIFont(),
            .foregroundColor: UIColor.white]
            appearance.buttonAppearance.normal.titleTextAttributes = [.font: UIFont(name: "NanumSquareRoundOTF", size: UIFont.labelFontSize) ?? UIFont(),
            .foregroundColor: UIColor.white]

            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance

        } else {
            //To change Navigation Bar Background Color
            UINavigationBar.appearance().barTintColor = UIColor.appColor(color: .mint)
        }

        let fontAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "NanumSquareRoundOTF", size: UIFont.labelFontSize)?.bold()
        ]

        //To change Back button title & icon color
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = fontAttributes
        UIBarButtonItem.appearance().setTitleTextAttributes(fontAttributes, for: .normal)
    }

    private func setNMFMapViewKey() {
        guard let value = KeyInfoLoader.loadValue(of: .NMFMapViewKey) else { return }
        NMFAuthManager.shared().clientId = value
    }

    private func executeAppUpdate(_ result: ConfigResult) {

        switch result {
        case .forcedUpdate:
            let forcedUpdateAction = UIAlertAction(title: "업데이트", style: .default) { (action) in
                self.openAppStore()
            }
            var alert = UIAlertController()
            alert = UIAlertController.make(message: .ForcedUpdate)
            alert.addAction(forcedUpdateAction)
            self.window?.rootViewController?.present(alert, animated: true, completion: nil)
        case .optionalUpdate:
            let allowUpdateAction = UIAlertAction(title: "네", style: .default) { (action) in
                self.openAppStore()
            }
            let denyUpdateAction = UIAlertAction(title: "아니요", style: .default) { (action) in
                // execute app & change root viewcontroller
                self.window?.rootViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateInitialViewController()
                return
            }
            var alert = UIAlertController()
            alert = UIAlertController.make(message: .OptionalUpdate)
            alert.addAction(allowUpdateAction)
            alert.addAction(denyUpdateAction)
            self.window?.rootViewController?.present(alert, animated: true, completion: nil)
        default:
            // execute app & change root viewcontroller
            self.window?.rootViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateInitialViewController()
            return
        }
    }

    private func openAppStore() {
        guard let appStoreURLRawValue = KeyInfoLoader.loadValue(of: .AppStoreScheme) else { return }
        if let appstoreScheme = URL(string: appStoreURLRawValue), UIApplication.shared.canOpenURL(appstoreScheme) {
                UIApplication.shared.open(appstoreScheme, options: [:], completionHandler: nil)
            }

        }
}

