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
    var topView: SlideTopView!

    override init() {
        super.init()
        self.background = SlideBackgroundView()
        self.topView = SlideTopView()
        NotificationCenter.default.addObserver(self, selector: #selector(handleDismiss), name: .slideMenuClose, object: nil)
    }

    private func add() {
        delegate.view.addSubview(background)
        delegate.view.addSubview(topView)
    }

    func set() {
        add()
        background.frame = self.delegate.view.frame
        background.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
        self.topView.backgroundColor = UIColor.yellow
    }

    func show() {
        background.show()
        topView.show()
    }

    @objc func handleDismiss() {
        UIView.animate(
            withDuration: 0.5, delay: 0, options: .curveEaseOut,
            animations: {
                self.background.dismiss()
                self.topView.dismiss()
        }, completion: nil)
    }

}


