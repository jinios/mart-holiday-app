//
//  SlideMenu.swift
//  MartHoliday
//
//  Created by YOUTH2 on 2018. 8. 17..
//  Copyright © 2018년 JINiOS. All rights reserved.
//

import UIKit

class SlideMenu: UIView {
    @IBOutlet var content: UIView!
    @IBOutlet weak var mainButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var nothingButton: UIButton!

    convenience init() {
        self.init(frame: CGRect(x: -(UIScreen.main.bounds.width/2), y: 0, width: UIScreen.main.bounds.width/2, height: UIScreen.main.bounds.height))
        Bundle.main.loadNibNamed("SlideMenuView", owner: self, options: nil)
        addSubview(content)
        content.frame = self.bounds
        content.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mainButton.setTitle("메인", for: .normal)
        searchButton.setTitle("검색", for: .normal)
        nothingButton.setTitle("버튼", for: .normal)
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

