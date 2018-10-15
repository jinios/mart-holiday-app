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
    case NMapGeoCodeURL
    case EmartList
    case LottemartList
    case HomeplusList
    case HomeplusExpressList
    case NMapSecretKey
    case NMapClientID
    case AcknowledgementsURL
}

