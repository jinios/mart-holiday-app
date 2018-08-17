//
//  SlideLauncher.swift
//  MartHoliday
//
//  Created by YOUTH2 on 2018. 8. 17..
//  Copyright © 2018년 JINiOS. All rights reserved.
//

import UIKit

class SlideLauncher: NSObject {

    var delegate: (UIViewController & SlideLauncherDelegate)!
    var background: SlideBackgroundView!
    var menu: SlideMenu!

    override init() {
        super.init()
        self.background = SlideBackgroundView()
        self.menu = SlideMenu()
    }

    private func add() {
        delegate.view.addSubview(background)
        delegate.view.addSubview(menu)
    }

    func set() {
        add()
        background.frame = self.delegate.view.frame
        background.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
        self.menu.backgroundColor = UIColor.yellow
    }

    func show() {
        background.show()
        menu.show()
    }

    @objc func handleDismiss() {
        UIView.animate(
            withDuration: 0.5, delay: 0, options: .curveEaseOut,
            animations: {
                self.background.dismiss()
                self.menu.dismiss()
        }, completion: nil)
    }

}


