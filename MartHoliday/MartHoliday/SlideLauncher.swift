//
//  SlideLauncher.swift
//  MartHoliday
//
//  Created by YOUTH2 on 2018. 8. 17..
//  Copyright © 2018년 JINiOS. All rights reserved.
//

import UIKit

class SlideLauncher: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    override init() {
        super.init()
        self.background = SlideBackgroundView()
        self.menu = SlideMenu()
        menu.delegate = self
        menu.dataSource = self
    }

    static let cellID = "cellID"

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SlideLauncher.cellID, for: indexPath) as! SlideMenuCell
        cell.setup()
        return cell
    }

    var delegate: (UIViewController & SlideLauncherDelegate)!
    var background: SlideBackgroundView!
    var menu: SlideMenu!

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


