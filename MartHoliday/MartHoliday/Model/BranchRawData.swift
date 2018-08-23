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
    var url: String
    var holidays: [String]
}

class BranchList {
    var branches: [Branch]

    init(branches: [BranchRawData]){
        self.branches = branches.map{ Branch(branch: $0) }
    }

    init(branchData: [Branch]) {
        self.branches = branchData
    }

    func count() -> Int {
        return self.branches.count
    }
}

class Branch: NSObject, NSCoding, Comparable {

    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "branchId")
        aCoder.encode(martType, forKey: "branchMartType")
        aCoder.encode(branchName, forKey: "branchName")
        aCoder.encode(region, forKey: "region")
        aCoder.encode(phoneNumber, forKey: "phoneNumber")
        aCoder.encode(address, forKey: "address")
        aCoder.encode(url, forKey: "url")
        aCoder.encode(holidays, forKey: "holidays")
        aCoder.encode(favorite, forKey: "favorite")
    }

    required init?(coder aDecoder: NSCoder) {
        id = aDecoder.decodeInteger(forKey: "branchId")
        martType = aDecoder.decodeObject(forKey: "branchMartType") as! String
        branchName = aDecoder.decodeObject(forKey: "branchName") as! String
        region = aDecoder.decodeObject(forKey: "region") as! String
        phoneNumber = aDecoder.decodeObject(forKey: "phoneNumber") as! String
        address = aDecoder.decodeObject(forKey: "address") as! String
        url = aDecoder.decodeObject(forKey: "url") as! String
        holidays = aDecoder.decodeObject(forKey: "holidays") as! [String]
        favorite = aDecoder.decodeBool(forKey: "favorite")
    }

    override var hashValue: Int {
        return self.id
    }

    override func isEqual(_ object: Any?) -> Bool {
        super.isEqual(object)
        guard let branch = object as? Branch else { return false }
        return self.id == branch.id
    }

    static func < (lhs: Branch, rhs: Branch) -> Bool {
        return lhs.hashValue < rhs.hashValue
    }

    var id: Int
    var martType: String
    var branchName: String
    var region: String
    var phoneNumber: String
    var address: String
    var url: String
    var holidays: [String]
    var favorite: Bool

    init(branch: BranchRawData) {
        self.id = branch.id
        self.martType = branch.martType
        self.branchName = branch.branchName
        self.region = branch.region
        self.phoneNumber = branch.phoneNumber
        self.address = branch.address
        self.url = branch.url
        self.holidays = branch.holidays
        self.favorite = FavoriteList.shared().isFavorite(branchId: id)
    }

    func toggleFavorite() -> Bool {
        if self.favorite {
            // self.favorite이 즐겨찾기일때 끄기
            guard FavoriteList.shared().pop(branch: self) else { return false }
        } else {
            // self.favorite이 즐겨찾기가 아닐때 켜기
            guard FavoriteList.shared().push(branch: self) else { return false }
        }
        favorite = !favorite
        return true
    }

}


