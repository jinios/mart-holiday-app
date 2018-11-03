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

    init() {
        super.init(frame: .zero)
        self.setImage(UIImage(named: "emptyStar"), for: .normal)
        self.setImage(UIImage(named: "yellowStar"), for: .selected)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setImage(UIImage(named: "emptyStar"), for: .normal)
        self.setImage(UIImage(named: "yellowStar"), for: .selected)
    }

    func toggleState() {
        self.isSelected = !self.isSelected
    }
}

class StarBarButton: StarButton {

    override init() {
        super.init()
        self.setImage(UIImage(named: "emptyStarBarButton"), for: .normal)
        self.setImage(UIImage(named: "yellowStarBarButton"), for: .selected)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setImage(UIImage(named: "emptyStarBarButton"), for: .normal)
        self.setImage(UIImage(named: "yellowStarBarButton"), for: .selected)
    }

}

class StarCircleButton: StarButton {

    override init() {
        super.init()
        self.setImage(UIImage(named: "star"), for: .normal)
        self.setImage(UIImage(named: "yellowCircleStar"), for: .selected)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setImage(UIImage(named: "star"), for: .normal)
        self.setImage(UIImage(named: "yellowCircleStar"), for: .selected)
    }

}

