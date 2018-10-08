//
//  FavoriteData.swift
//  MartHoliday
//
//  Created by YOUTH2 on 08/10/2018.
//  Copyright © 2018 JINiOS. All rights reserved.
//

import Foundation

protocol APIDataComparable: Equatable {
    var token: String {get}
    var favorites: [Int] {get}
}

class FavoriteData: APIDataComparable {

    var token: String
    var favorites: [Int]

    init(token: String, favorites: [Int]) {
        self.token = token
        self.favorites = favorites
    }

    static func == (lhs: FavoriteData, rhs: FavoriteData) -> Bool {
        return (lhs.token == rhs.token) && (lhs.favorites == rhs.favorites)
    }

    func isSame(otherData: FavoriteData) -> Bool {
        return self == otherData
    }

}
