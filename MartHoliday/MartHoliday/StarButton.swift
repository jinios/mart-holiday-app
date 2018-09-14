//
//  StarButton.swift
//  MartHoliday
//
//  Created by YOUTH2 on 2018. 9. 10..
//  Copyright © 2018년 JINiOS. All rights reserved.
//

import UIKit

class StarButton: UIButton {

    func setImage() {
        self.setImage(UIImage(named: "emptyStar"), for: .normal)
        self.setImage(UIImage(named: "yellowStar"), for: .selected)
    }

    func toggleState() {
        self.isSelected = !self.isSelected
    }
}

protocol FavoriteTogglable {
    var starButton: StarButton! { get set }
    func toggleState()
    func setStarButton()
}
