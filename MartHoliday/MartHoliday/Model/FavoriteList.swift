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

    static func isSameData(_ data: FavoriteList) -> Bool {
        return sharedFavorite.favoriteList == data.favoriteList
    }

    private(set) var favoriteList: Set<Int>

    func push(branchID: Int) -> Bool {
        return self.favoriteList.insert(branchID).inserted
    }

    func pop(branchID: Int) -> Bool {
        var popResult: Bool
        let result = self.favoriteList.remove(branchID)
        if result != nil {
            popResult = true
        } else {
            popResult = false
        }
        return popResult
    }

    func isFavorite(id: Int) -> Bool {
        return self.favoriteList.contains(id)
    }
}
