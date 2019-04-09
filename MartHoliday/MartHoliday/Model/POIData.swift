//
//  POIData.swift
//  MartHoliday
//
//  Created by YOUTH2 on 05/03/2019.
//  Copyright © 2019 JINiOS. All rights reserved.
//

import Foundation

// To mark as a poi flag on a map
class POIData {

    var values: [POIDatum]
    var count: Int
    subscript(index: Int) -> POIDatum {
        return values[index]
    }

    init(rawData: [BranchRawData]) {
        var data = [POIDatum]()
        for i in 0..<rawData.count {
            data.append(POIDatum(rawData: rawData[i], index: i))
        }
        self.values = data
        self.count = rawData.count
    }

    init(list: BranchList) {
        var data = [POIDatum]()
        for i in 0..<list.count() {
            data.append(POIDatum(branch: list[i], index: i))
        }
        self.values = data
        self.count = list.count()
    }

}

class POIDatum {

    var branch: Branch
    var POIindex: Int?
    lazy var nGeoPoint: NGeoPoint = {
        return NGeoPoint(longitude: self.branch.longitude, latitude: self.branch.latitude)
    }()

    init(rawData: BranchRawData, index: Int) {
        self.branch = Branch(branch: rawData)
        self.POIindex = index
    }

    init(branch: Branch, index: Int) {
        self.branch = branch
        self.POIindex = index
    }
}
