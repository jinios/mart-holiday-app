//
//  SlideLauncher.swift
//  MartHoliday
//
//  Created by YOUTH2 on 2018. 8. 17..
//  Copyright © 2018년 JINiOS. All rights reserved.
//

import UIKit

class SlideLauncher: NSObject {

    static let slideMenuDivider: CGFloat = 100
    static let cellID = "cellID"

    var delegate: (UIViewController & SlideLauncherDelegate)!
    var background: SlideBackgroundView!
    var topView: SlideTopView!
    var slideMenu: SlideMenu!
    var openFlag: Bool?

    let menuData = [MenuData(title: "메인으로", imageName: "home"),
                    MenuData(title: "마트검색", imageName: "search-2")]

    override init() {
        super.init()
        self.background = SlideBackgroundView()
        self.topView = SlideTopView()
        self.slideMenu = SlideMenu()
        slideMenu.dataSource = self
        slideMenu.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(handleDismiss), name: .slideMenuClose, object: nil)
    }

    private func add() {
        delegate.view.addSubview(background)
        delegate.view.addSubview(topView)
        delegate.view.addSubview(slideMenu)
    }

    func set() {
        self.openFlag = false
        add()
        background.frame = self.delegate.view.frame
        background.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
    }

    func show() {
        guard let openFlag = self.openFlag else { return }
        if openFlag == false {
            background.show()
            topView.show()
            slideMenu.show()
            self.openFlag = true
        }
    }

    @objc func handleDismiss() {
        guard let openFlag = self.openFlag else { return }
        if openFlag == true {
            UIView.animate(
                withDuration: 0.5, delay: 0, options: .curveEaseOut,
                animations: {
                    self.background.dismiss()
                    self.topView.dismiss()
                    self.slideMenu.dismiss()
            }) { complete in
                if complete {
                    self.openFlag! = false
                } else {
                    return
                }
            }
        }
    }

    func isOpened() -> Bool {
        guard let result = self.openFlag else { return false }
        return result
    }

}

extension SlideLauncher: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = slideMenu.dequeueReusableCell(withReuseIdentifier: SlideLauncher.cellID, for: indexPath) as! SlideMenuCell
        cell.setData(menu: menuData[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let menuData = self.menuData[indexPath.row]
        UIView.animate(
            withDuration: 0.5, delay: 0, options: .curveEaseOut,
            animations: {
                self.background.dismiss()
                self.topView.dismiss()
                self.slideMenu.dismiss()
        }) { (completed: Bool) in
            NotificationCenter.default.post(name: .slideMenuTapped, object: nil, userInfo: ["next": menuData.destinationInfo()])
        }
    }

}

extension SlideLauncher: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: slideMenu.frame.width, height: 70)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

class MenuData {
    var title: String
    var imageName: String

    init(title: String, imageName: String) {
        self.title = title
        self.imageName = imageName
    }

    func destinationInfo() -> SelectedSlideMenu {
        switch self.title {
        case "메인으로": return .main
        case "마트검색": return .select
        default: return .main
        }
    }
}

enum SelectedSlideMenu {
    case main
    case select
}
