//
//  Extensions.swift
//  MartHoliday
//
//  Created by YOUTH2 on 2018. 8. 15..
//  Copyright © 2018년 JINiOS. All rights reserved.
//

import UIKit

extension Notification.Name {
    static let favoriteChanged = Notification.Name("favoriteChanged")
    static let slideMenuClose = Notification.Name("slideMenuClose")
}

extension UIButton {
    func setStarIconImage() {
        self.setImage(UIImage(named: "emptyStar"), for: .normal)
        self.setImage(UIImage(named: "yellowStar"), for: .selected)
    }

    func toggleSelectedState() {
        self.isSelected = !self.isSelected
    }
}
