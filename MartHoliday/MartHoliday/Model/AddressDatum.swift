//
//  AddressDatum.swift
//  MartHoliday
//
//  Created by YOUTH2 on 2018. 8. 29..
//  Copyright © 2018년 JINiOS. All rights reserved.
//

import Foundation

struct AddressDatum: Codable {
    var result: Result

    func geoPoint() -> GeoPoint {
        return result.items[0].point
    }
}

struct Result: Codable {
    var total: Int
    var userquery: String
    var items: [Item]
}

struct Item: Codable {
    var address: String
    var addrdetail: AddressDetail
    var isRoadAddress: Bool
    var point: GeoPoint
}

struct AddressDetail: Codable {
    var country: String
    var sido: String
    var sigugun: String
    var dongmyun: String
    var ri: String
    var rest: String
}

struct GeoPoint: Codable {
    var x: Double
    var y: Double
}
