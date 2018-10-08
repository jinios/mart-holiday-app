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
    var deviceToken: String!

    static var shared: FavoriteAPI {
        return sharedInstance
    }

    private init() { }

    func configure(token: String) {
        deviceToken = token
    }

    private func setFavoriteFromDB(handler: @escaping(FavoriteList) -> Void) {
        let ref = Database.database().reference()
        //DeviceToken값으로 현재 파이어베이스에 있는 값 가져오고 FavoriteList fetch까지
        ref.child("users").child(deviceToken).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? Dictionary<String,AnyObject>
            let fdata = value?["favorites"] as? [Int] ?? [0]
//            print(value)
//            print(fdata)

            let loadedFavorites = FavoriteList.sharedIdsFromDB(fdata)

            handler(loadedFavorites)
        }) { (error) in
            print(error.localizedDescription)
        }
    }

    func fetch() -> [Int]{
        //DeviceToken값으로 현재 파이어베이스에 있는 값 가져오기
        var favoriteData: [Int]!
        let ref = Database.database().reference()
        ref.child("users").child(deviceToken).observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as? Dictionary<String,AnyObject>
            favoriteData = value?["favorites"] as? [Int] ?? [0]
        }
        return favoriteData
    }

}
