//
//  AppDelegate.swift
//  MartHoliday
//
//  Created by YOUTH2 on 2018. 8. 10..
//  Copyright © 2018년 JINiOS. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        guard let loadedData = DataStorage<FavoriteList>.load() else { return true }
        FavoriteList.loadSavedData(loadedData) // Favorite리스트를 저장했던 인스턴스로 대체해줌
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        DataStorage<FavoriteList>.save(data: FavoriteList.shared())
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        DataStorage<FavoriteList>.save(data: FavoriteList.shared())
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        guard let loadedData = DataStorage<FavoriteList>.load() else { return }
        // background상태로 가면서 저장했던 인스턴스로 대체해주는데, background로 가면서 저장했던 데이터와 같으면 대체를안하고 다르면 새 데이터로 대체함
        if !FavoriteList.isSameData(loadedData) {
            FavoriteList.loadSavedData(loadedData)
        }
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        DataStorage<FavoriteList>.save(data: FavoriteList.shared())
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

