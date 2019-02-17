//
//  BranchList.swift
//  MartHoliday
//
//  Created by YOUTH2 on 2018. 9. 8..
//  Copyright © 2018년 JINiOS. All rights reserved.
//

import Foundation

class BranchList {
    var branches: [Branch]

    subscript(index: Int) -> Branch {
        get {
            return branches[index]
        }
    }

    init() {
        self.branches = [Branch]()
    }

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

class Branch: NSObject, Comparable {

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
    var openingHours: String
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
        self.openingHours = branch.openingHours
        self.url = branch.url
        self.holidays = branch.holidays
        self.favorite = FavoriteList.shared().isFavorite(branchId: id)
    }

    func toggleFavorite() -> Bool {
        if self.favorite {
            // self.favorite이 즐겨찾기일때 끄기
            guard FavoriteList.shared().pop(id: self.id) else { return false }
        } else {
            // self.favorite이 즐겨찾기가 아닐때 켜기
            guard FavoriteList.shared().push(id: self.id) else { return false }
        }
        favorite = !favorite
        return true
    }

    func martName() -> String {
        switch self.martType {
        case "홈플러스 익스프레스": return "홈플러스EX"
        default: return martType
        }
    }

    func displayName() -> String {
        return "\(martName()) \(self.branchName)"
    }

}

