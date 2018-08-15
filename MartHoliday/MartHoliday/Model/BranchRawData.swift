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

class Branch {
    private let branch: BranchRawData

    let id: Int
    let martType: String
    let branchName: String
    let region: String
    let phoneNumber: String
    let address: String
    let url: String
    let holidays: [String]
    var favorite: Bool

    init(branch: BranchRawData) {
        self.branch = branch
        self.id = branch.id
        self.martType = branch.martType
        self.branchName = branch.branchName
        self.region = branch.region
        self.phoneNumber = branch.phoneNumber
        self.address = branch.address
        self.url = branch.url
        self.holidays = branch.holidays
        self.favorite = FavoriteList.shared().isFavorite(id: branch.id)
    }

    func toggleFavorite() -> Bool {
        if self.favorite {
            // self.favorite이 즐겨찾기일때 끄기
            guard FavoriteList.shared().pop(branchID: self.id) else { return false }
        } else {
            // self.favorite이 즐겨찾기가 아닐때 켜기
            guard FavoriteList.shared().push(branchID: self.id) else { return false }
        }
        favorite = !favorite
        NotificationCenter.default.post(name: .favoriteChanged, object: nil, userInfo: ["favoriteChangeResult": true])
        return true
    }

}


