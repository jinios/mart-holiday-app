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
    func firstHoliday() -> String
    func allHolidays() -> [String]
    func branchName() -> String
}

class FavoriteBranch: ExpandCollapseTogglable {
    var isExpanded: Bool
    var branch: Branch
    private var holidays: [String]
    lazy var isEmpty: Bool = {
        return holidays.isEmpty
    }()

    init(branch: Branch) {
        self.branch = branch
        isExpanded = false
        self.holidays = branch.holidays
        if self.holidays.isEmpty {
            self.holidays.append(ProgramDescription.NoDateData.rawValue)
        }
    }

    func toggleExpand() {
        isExpanded = !isExpanded
    }

    func firstHoliday() -> String {
        guard holidays.isEmpty else { return holidays[0] }
        return ProgramDescription.NoDateData.rawValue
    }

    func allHolidays() -> [String] {
        return holidays
    }

    func branchName() -> String {
        return "\(branch.martName()) \(branch.branchName)"
    }
}

