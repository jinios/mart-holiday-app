//
//  MartHolidayTests.swift
//  MartHolidayTests
//
//  Created by YOUTH2 on 2018. 9. 10..
//  Copyright © 2018년 JINiOS. All rights reserved.
//

import XCTest

class MartHolidayTests: XCTestCase {

    func testDeletedFavorite() {
        let favorite = FavoriteList.shared()
        favorite.push(id: 1)
        favorite.push(id: 40)
        favorite.push(id: 323)
        XCTAssertEqual([1,40,323], favorite.ids())
    }
    
}
