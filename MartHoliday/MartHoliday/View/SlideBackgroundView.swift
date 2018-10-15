//
//  SlideBackgroundView.swift
//  MartHoliday
//
//  Created by YOUTH2 on 2018. 8. 17..
//  Copyright © 2018년 JINiOS. All rights reserved.
//

import UIKit

class SlideBackgroundView: UIView {

    convenience init() {
        self.init(frame: UIScreen.main.bounds)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.alpha = 0
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.alpha = 0
    }

    func show() {
        self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.alpha = 0

        UIView.animate(withDuration: 0.5) {
            self.alpha = 1
        }
    }

    func dismiss() {
        self.alpha = 0
    }

}
