//
//  SlideTopView.swift
//  MartHoliday
//
//  Created by YOUTH2 on 2018. 8. 17..
//  Copyright © 2018년 JINiOS. All rights reserved.
//

import UIKit

class SlideTopView: UIView {
    @IBOutlet var content: UIView!

    convenience init() {
        self.init(frame: CGRect(x: -(UIScreen.main.bounds.width/2), y: 0, width: UIScreen.main.bounds.width/2, height: SlideLauncher.slideMenuDivider))
        Bundle.main.loadNibNamed("SlideMenuView", owner: self, options: nil)
        addSubview(content)
        content.frame = self.bounds
        content.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @IBAction func closeButtonTapped(_ sender: Any) {
        NotificationCenter.default.post(name: .slideMenuClose, object: nil)
    }

    func add(to superview: UIViewController) {
        superview.view.addSubview(self)
    }

    func show() {
        UIView.animate(
            withDuration: 0.5, delay: 0, options: .curveEaseOut,
            animations: {
                self.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        }, completion: nil)
    }

    func dismiss() {
        self.frame = CGRect(x: -(self.frame.width), y: 0, width: self.frame.width, height: self.frame.height)
    }
}


