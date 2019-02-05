//
//  DistanceSearch.swift
//  MartHoliday
//
//  Created by YOUTH2 on 04/02/2019.
//  Copyright © 2019 JINiOS. All rights reserved.
//

import Foundation
import AlamofireObjectMapper
import ObjectMapper
import Alamofire

class DistanceSearch {

    class func fetch(geoPoint: NGeoPoint, distance: Int, handler: @escaping (() -> Void)) {
        guard let value = KeyInfoLoader.loadValue(of: .BaseURL) else { return }
        guard let baseURL = URL(string: value) else { return }
        let params: [String:Any] = ["latitude":geoPoint.latitude, "longitude":geoPoint.longitude, "distance":distance]

        Alamofire.request(baseURL, parameters: params).responseArray(keyPath: "data") { (response: DataResponse<[TempBranchRaw]>) in

            if let statusCode = response.response?.statusCode, 200...299 ~= statusCode {
                if response.result.isSuccess {
                    // fetch branch
                }
            } else {
                // error
            }
        }
    }

}




// keyPath: "data"
class TempBranchRaw: Mappable {

    var id: Int?
    var martType: String?
    var branchName: String?
    var region: String?
    var phoneNumber: String?
    var address: String?
    var openingHours: String?
    var url: String?
    var holidays: [String]?
    var latitude: Double?
    var longitude: Double?

    required init?(map: Map) {

    }

    func mapping(map: Map) {
        id <- map["id"]
        martType <- map["martType"]
        branchName <- map["branchName"]
        region <- map["region"]
        phoneNumber <- map["phoneNumber"]
        address <- map["address"]
        openingHours <- map["openingHours"]
        url <- map["url"]
        holidays <- map["holidays"]
        // nested keyPath: "location"
        latitude <- map["location.latitude"]
        longitude <- map["location.longitude"]
    }

}

