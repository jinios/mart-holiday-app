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
        aCoder.encode(martSet, forKey: String(describing: FavoriteList.self))
    }

    required init?(coder aDecoder: NSCoder) {
        martSet = aDecoder.decodeObject(forKey: String(describing: FavoriteList.self)) as! Set<Branch>
    }

    private static var sharedFavorite = FavoriteList()

    override init() {
        self.martSet = Set<Branch>()
    }

    static func shared() -> FavoriteList {
        return sharedFavorite
    }

    static func loadSavedData(_ data: FavoriteList) {
        sharedFavorite = data
    }

    static func isSameData(_ data: FavoriteList) -> Bool {
        return sharedFavorite.martSet == data.martSet
    }

    private var martSet: Set<Branch>


    func push(branch: Branch) -> Bool {
        return self.martSet.insert(branch).inserted
    }

    func pop(branch: Branch) -> Bool {
        var popResult: Bool
        let result = self.martSet.remove(branch)
        if result != nil {
            popResult = true
        } else {
            popResult = false
        }
        return popResult
    }

    func isFavorite(branchId: Int) -> Bool {
        guard martSet.count > 0 else { return false }
        let martIdList = martSet.map { $0.id }
        return martIdList.contains(branchId)
    }

    func martList() -> [Branch] {
        return martSet.sorted { $0.id > $1.id }
    }
}

