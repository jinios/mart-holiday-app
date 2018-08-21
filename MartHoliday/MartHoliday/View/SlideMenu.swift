//
//  SlideMenu.swift
//  MartHoliday
//
//  Created by YOUTH2 on 2018. 8. 18..
//  Copyright © 2018년 JINiOS. All rights reserved.
//

import UIKit

class SlideMenu: UICollectionView {

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.backgroundColor = UIColor.white
        self.register(SlideMenuCell.self, forCellWithReuseIdentifier: MainViewController.cellID)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func add(to superview: UIViewController) {
        superview.view.addSubview(self)
    }

    func show() {
        UIView.animate(
            withDuration: 0.5, delay: 0, options: .curveEaseOut,
            animations: {
                let currentY = self.frame.minY
                self.frame = CGRect(x: 0, y: currentY, width: self.frame.width, height: self.frame.height)
        }, completion: nil)

    }

    func dismiss() {
        let currentY = self.frame.minY
        self.frame = CGRect(x: -(self.frame.width), y: currentY, width: self.frame.width, height: self.frame.height)
    }
}
