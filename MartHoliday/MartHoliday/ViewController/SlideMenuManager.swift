//
//  SlideMenuManager.swift
//  MartHoliday
//
//  Created by YOUTH2 on 2018. 8. 24..
//  Copyright © 2018년 JINiOS. All rights reserved.
//

import Foundation

class SlideMenuManager: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    let menuData = [MenuData(title: "메인으로", imageName: "home"),
                    MenuData(title: "마트검색", imageName: "search-2")]


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: collectionView.frame.width, height: 70)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return menuData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainViewController.cellID, for: indexPath) as! SlideMenuCell
            cell.setData(menu: menuData[indexPath.row])
            return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let menuData = self.menuData[indexPath.row]
            NotificationCenter.default.post(name: .slideMenuTapped, object: nil, userInfo: ["next": menuData.destinationInfo()])
    }

}