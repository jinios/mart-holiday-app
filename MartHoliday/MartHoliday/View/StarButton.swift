//
//  StarButton.swift
//  MartHoliday
//
//  Created by YOUTH2 on 2018. 9. 10..
//  Copyright © 2018년 JINiOS. All rights reserved.
//

import UIKit

protocol FavoriteTogglable {
    var starButton: StarButton! { get set }
    func toggleState()
    func setStarButton()
}

class StarButton: UIButton {

    func setImage() {
        self.setImage(UIImage(named: "emptyStar"), for: .normal)
        self.setImage(UIImage(named: "yellowStar"), for: .selected)
    }

    func toggleState() {
        self.isSelected = !self.isSelected
    }
}

class StarBarButton: StarButton {
    override func setImage() {
        self.setImage(UIImage(named: "emptyStarBarButton"), for: .normal)
        self.setImage(UIImage(named: "yellowStarBarButton"), for: .selected)
    }
}

class StarCircleButton: StarButton {
    override func setImage() {
        self.setImage(UIImage(named: "star"), for: .normal)
        self.setImage(UIImage(named: "yellowCircleStar"), for: .selected)
    }
}

