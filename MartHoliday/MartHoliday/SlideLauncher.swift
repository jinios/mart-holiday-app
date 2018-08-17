//
//  SlideLauncher.swift
//  MartHoliday
//
//  Created by YOUTH2 on 2018. 8. 17..
//  Copyright © 2018년 JINiOS. All rights reserved.
//

import UIKit

class SlideLauncher: UIView {

    func showSettings() {
        self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
        self.frame = self.superview!.frame
        self.alpha = 0

        UIView.animate(withDuration: 0.5) {
            self.alpha = 1
        }
    }

    @objc func handleDismiss() {
        UIView.animate(withDuration: 0.5) {
            self.alpha = 0
        }
    }
}

