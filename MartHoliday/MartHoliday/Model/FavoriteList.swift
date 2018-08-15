//
//  FavoriteList.swift
//  MartHoliday
//
//  Created by YOUTH2 on 2018. 8. 15..
//  Copyright © 2018년 JINiOS. All rights reserved.
//

import Foundation

class FavoriteList: NSObject, NSCoding {

    func encode(with aCoder: NSCoder) {
        aCoder.encode(FavoriteList.favoriteList, forKey: "favorite")
    }

    required init?(coder aDecoder: NSCoder) {
        FavoriteList.favoriteList = aDecoder.decodeObject(forKey: "favorite") as! Set<Int>
    }

    private static var sharedFavorite = FavoriteList()

    override init() { }

    static func shared() -> FavoriteList {
        return sharedFavorite
    }

    static func loadSavedData(_ data: FavoriteList) {
        sharedFavorite = data
    }

    static private(set) var favoriteList = Set<Int>()

    static func push(branchID: Int) {
        self.favoriteList.insert(branchID)
    }

    static func pop(branchID: Int) {
        self.favoriteList.remove(branchID)
    }

    static func isFavorite(id: Int) -> Bool {
        return favoriteList.contains(id)
    }
}

