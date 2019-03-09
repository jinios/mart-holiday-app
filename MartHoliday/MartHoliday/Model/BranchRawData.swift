//
//  Branch.swift
//  MartHoliday
//
//  Created by YOUTH2 on 2018. 8. 11..
//  Copyright © 2018년 JINiOS. All rights reserved.
//

import Foundation

struct BranchRawData: Codable {
    var id: Int
    var martType: String
    var branchName: String
    var region: String
    var phoneNumber: String
    var address: String
    var openingHours: String
    var url: String
    var holidays: [String]
    var latitude: Double?
    var longitude: Double?

    enum CodingKeys: String, CodingKey {
        case id
        case martType
        case branchName
        case region
        case phoneNumber
        case address
        case openingHours
        case url
        case holidays
        case location
        case latitude
        case longitude
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(Int.self, forKey: .id)
        self.martType = try container.decode(String.self, forKey: .martType)
        self.branchName = try container.decode(String.self, forKey: .branchName)
        self.region = try container.decode(String.self, forKey: .region)
        self.phoneNumber = try container.decode(String.self, forKey: .phoneNumber)
        self.address = try container.decode(String.self, forKey: .address)
        self.openingHours = try container.decode(String.self, forKey: .openingHours)
        self.url = try container.decode(String.self, forKey: .url)
        self.holidays = try container.decode([String].self, forKey: .holidays)

        let location = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .location)
        self.latitude = try location.decode(Double?.self, forKey: .latitude)
        self.longitude = try location.decode(Double?.self, forKey: .longitude)
    }

    func encode(to encoder: Encoder) throws {
        var container = try encoder.container(keyedBy: CodingKeys.self)

        try container.encode(id, forKey: .id)
        try container.encode(martType, forKey: .martType)
        try container.encode(branchName, forKey: .branchName)
        try container.encode(region, forKey: .region)
        try container.encode(phoneNumber, forKey: .phoneNumber)
        try container.encode(address, forKey: .address)
        try container.encode(openingHours, forKey: .openingHours)
        try container.encode(url, forKey: .url)
        try container.encode(holidays, forKey: .holidays)

        var location = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .location)
        try location.encode(latitude, forKey: .latitude)
        try location.encode(longitude, forKey: .longitude)
    }
}
