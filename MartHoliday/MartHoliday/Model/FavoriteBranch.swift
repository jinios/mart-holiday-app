//
//  FavoriteBranch.swift
//  MartHoliday
//
//  Created by YOUTH2 on 2018. 9. 26..
//  Copyright © 2018년 JINiOS. All rights reserved.
//

import Foundation

protocol ExpandCollapseTogglable {
    var isExpanded: Bool { get set }
    func toggleExpand()
}

class FavoriteBranch: ExpandCollapseTogglable {
    var isExpanded: Bool
    var branch: Branch
    private var holidays: [String]

    init(branch: Branch) {
        self.branch = branch
        isExpanded = false
        self.holidays = branch.holidays
        if self.holidays.isEmpty {
            self.holidays.append("휴무일 정보가 없습니다 :(")
        }
    }

    func toggleExpand() {
        isExpanded = !isExpanded
    }

    func firstHoliday() -> String {
        guard holidays.isEmpty else { return holidays[0] }
        return "휴무일 정보가 없습니다 :("
    }

    func allHolidays() -> [String] {
        return holidays
    }

    func branchName() -> String {
        return "\(branch.martName()) \(branch.branchName)"
    }
}

