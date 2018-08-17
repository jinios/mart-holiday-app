//
//  SlideBackgroundView.swift
//  MartHoliday
//
//  Created by YOUTH2 on 2018. 8. 17..
//  Copyright © 2018년 JINiOS. All rights reserved.
//

import UIKit

class SlideBackgroundView: UIView {

    func add(to superview: UIViewController) {
        superview.view.addSubview(self)
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
