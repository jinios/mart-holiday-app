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

//    class func loadNMapKeySet() -> (id: Any, secretKey: Any)? {
//        if let path = Bundle.main.path(forResource: "KeyInfo", ofType: "plist"){
//            guard let myDict = NSDictionary(contentsOfFile: path) else { return nil }
//            let appID = myDict["NMapClientID"]!
//            let secretKey = myDict["NMapSecretKey"]!
//            return (id: appID, secretKey: secretKey)
//        }
//        return nil
//    }

}

enum KeyInfo: String {
    case FavoriteBranchesURL
    case EmartList
    case TradersList
    case CostcoList
    case LottemartList
    case HomeplusList
    case HomeplusExpressList
//    case NMapSecretKey
//    case NMapClientID
    case AcknowledgementsURL
    case BaseURL
    case NMFMapViewKey
    case AppStoreScheme
}

