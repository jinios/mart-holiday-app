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
}

class Branch {
    let branch: BranchRawData
    var favorite: Bool = false

    init(branch: BranchRawData) {
        self.branch = branch
    }

    func toggleFavorite() {
        self.favorite = !favorite
    }

}


