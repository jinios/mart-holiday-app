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
        martSet = aDecoder.decodeObject(forKey: String(describing: FavoriteList.self)) as! Set<Int>
    }

    private static var sharedFavorite = FavoriteList()

    private override init() {
        self.martSet = Set<Int>()
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

    private var martSet: Set<Int> {
        didSet {
            DataStorage<FavoriteList>.save(data: self)
        }
    }

    func push(id: Int) -> Bool {
        return self.martSet.insert(id).inserted
    }

    func pop(id: Int) -> Bool {
        var popResult: Bool
        let result = self.martSet.remove(id)
        if result != nil {
            popResult = true
        } else {
            popResult = false
        }
        return popResult
    }

    func isFavorite(branchId: Int) -> Bool {
        guard martSet.count > 0 else { return false }
        return martSet.contains(branchId)
    }

    func martList() -> [Int] {
        return martSet.sorted { $0 > $1 }
    }

    func ids() -> [Int] {
        return martSet.sorted()
    }

}

