//
//  HolidaysCollectionViewManager.swift
//  MartHoliday
//
//  Created by YOUTH2 on 2018. 9. 2..
//  Copyright © 2018년 JINiOS. All rights reserved.
//

import Foundation

class HolidaysCollectionViewManager: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var dates: [String]

    init(dates: [String]) {
        self.dates = dates
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dates.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "holidaysCell", for: indexPath) as? HolidaysCell else { return UICollectionViewCell() }
        cell.setData(text: dates[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width/2.3), height: collectionView.frame.height/2.8)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }

}

