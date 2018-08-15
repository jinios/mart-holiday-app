//
//  FavoriteList.swift
//  MartHoliday
//
//  Created by YOUTH2 on 2018. 8. 15..
//  Copyright © 2018년 JINiOS. All rights reserved.
//

import Foundation

class FavoriteList {
    private static var sharedFavorite = FavoriteList()
    private static var favoriteList = Set<Int>()

    init() {

    }

    static func shared() -> FavoriteList {
        return sharedFavorite
    }

    static func loadSavedData(_ data: FavoriteList) {
        sharedFavorite = data
    }

    static func push(branchID: Int) {
        //        guard !self.favoriteList.contains(branchID) else { return }
        self.favoriteList.insert(branchID)
    }

    static func pop(branchID: Int) {
        //        guard !self.favoriteList.contains(branchID) else { return }
        self.favoriteList.remove(branchID)
    }

}

/*
 class VendingMachine: NSObject, NSCoding, DefaultMode, AdminMode, UserMode {
 private static var sharedVendingMachine = VendingMachine()

 private override convenience init() {
 self.init(stockItems: AdminController().setVendingMachineStock(unit: 1))
 }

 class func shared() -> VendingMachine {
 return sharedVendingMachine
 }

 class func loadData(_ data: VendingMachine) {
 sharedVendingMachine = data
 }

 func encode(with aCoder: NSCoder) {
 aCoder.encode(stock, forKey: "stock")
 aCoder.encode(balance, forKey: "balance")
 }

 required init?(coder aDecoder: NSCoder) {
 stock = aDecoder.decodeObject(forKey: "stock") as! StockController
 balance = aDecoder.decodeObject(forKey: "balance") as! Money
 }

 private(set) var stock = StockController(items: [Beverage]())
 private var balance = Money()

 init(stockItems: [Beverage]) {
 super.init()
 self.stock = StockController(items: stockItems)
 }
 */

