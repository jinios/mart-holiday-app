//
//  KeyInfoLoader.swift
//  MartHoliday
//
//  Created by YOUTH2 on 10/10/2018.
//  Copyright © 2018 JINiOS. All rights reserved.
//

import Foundation

class KeyInfoLoader {

    static let path = Bundle.main.path(forResource: "KeyInfo", ofType: "plist")

    class func loadValue(of key: KeyInfo) -> String? {
        guard let path = path else { return nil }
        guard let myDict = NSDictionary(contentsOfFile: path) else { return nil }
        guard let value = myDict[key.rawValue] as? String else { return nil }
        return value
    }

}

enum KeyInfo: String {
    case FavoriteBranchesURL
    case EmartList
    case TradersList
    case CostcoList
    case LottemartList
    case HomeplusList
    case HomeplusExpressList
    case NobrandList
    case AcknowledgementsURL
    case BaseURL
    case NMFMapViewKey
    case AppStoreScheme
}


