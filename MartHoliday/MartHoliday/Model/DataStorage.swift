//
//  DataStorage.swift
//  MartHoliday
//
//  Created by YOUTH2 on 2018. 8. 15..
//  Copyright © 2018년 JINiOS. All rights reserved.
//

import Foundation

class DataStorage<T> {

    class func load() -> T? {
        // 존재확인
        if UserDefaults.standard.object(forKey: String(describing: T.self)) != nil {
            // key값으로 데이터 가져옴
            guard let encodedData = UserDefaults.standard.data(forKey: String(describing: T.self)) else { return nil }
            guard let archivedMachine = NSKeyedUnarchiver.unarchiveObject(with: encodedData) as? FavoriteList else { return nil }
            return archivedMachine as? T
        }
        return nil
    }

    class func saveVendingMachine(data: T) {
        UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: data), forKey: String(describing: T.self))
    }
}
