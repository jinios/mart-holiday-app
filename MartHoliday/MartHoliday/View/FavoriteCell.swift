//
//  FavoriteCell.swift
//  MartHoliday
//
//  Created by YOUTH2 on 2018. 8. 23..
//  Copyright © 2018년 JINiOS. All rights reserved.
//

import Foundation

class FavoriteCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var holidaysCollectionView: UICollectionView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = UIColor.white
        print(type(of:holidaysCollectionView))
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        holidaysCollectionView.backgroundColor = UIColor.white
    }

    var dateData: [String]!

    func setData(branch: Branch) {
        title.text = "\(branch.martType) \(branch.branchName)"
        self.dateData = branch.holidays
        holidaysCollectionView.delegate = self
        holidaysCollectionView.dataSource = self
        holidaysCollectionView.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dateData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "holidaysCell", for: indexPath) as! HolidaysCell
        cell.setData(text: dateData[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 2.5, height: collectionView.frame.height/2.5)

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }


}
