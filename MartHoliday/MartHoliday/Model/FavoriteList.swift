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
        aCoder.encode(favoriteList, forKey: String(describing: FavoriteList.self))
    }

    required init?(coder aDecoder: NSCoder) {
        favoriteList = aDecoder.decodeObject(forKey: String(describing: FavoriteList.self)) as! Set<Int>
    }

    private static var sharedFavorite = FavoriteList()

    override init() {
        self.favoriteList = Set<Int>()
    }

    static func shared() -> FavoriteList {
        return sharedFavorite
    }

    static func loadSavedData(_ data: FavoriteList) {
        sharedFavorite = data
    }

    private(set) var favoriteList: Set<Int>

    func push(branchID: Int) {
        self.favoriteList.insert(branchID)
    }

    func pop(branchID: Int) {
        self.favoriteList.remove(branchID)
    }

    func isFavorite(id: Int) -> Bool {
        return self.favoriteList.contains(id)
    }
}

