//
//  FavoriteAPI.swift
//  MartHoliday
//
//  Created by YOUTH2 on 2018. 10. 6..
//  Copyright © 2018년 JINiOS. All rights reserved.
//

import Foundation
import Firebase

class FavoriteAPI {
    private static var sharedInstance = FavoriteAPI()
    var deviceToken: String?

    static var shared: FavoriteAPI {
        return sharedInstance
    }

    private init() { }

    func configure(token: String) {
        deviceToken = token
    }

    func fetch(handler: @escaping(FavoriteList) -> Void) {
        //DeviceToken값으로 현재 파이어베이스에 있는 값 즐겨찾기에 세팅
        guard let deviceToken = deviceToken else { return }
        let ref = Database.database().reference()
        ref.child("users").child(deviceToken).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? Dictionary<String,AnyObject>
            let fdata = value?["favorites"] as? [Int] ?? [0]
            let loadedFavorites = FavoriteList.sharedIdsFromDB(fdata)
            handler(loadedFavorites)
        }) { (error) in
            print(error.localizedDescription)
        }
    }

    // 파이어베이스에 값 저장/업데이트
    func save() {
        guard let deviceToken = deviceToken else { return }
        let ref = Database.database().reference()
        ref.child("users").child(deviceToken).setValue(["favorites": FavoriteList.shared().ids()])
    }

}

