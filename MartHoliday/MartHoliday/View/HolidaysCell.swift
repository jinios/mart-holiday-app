//
//  HolidaysCell.swift
//  MartHoliday
//
//  Created by YOUTH2 on 2018. 8. 25..
//  Copyright © 2018년 JINiOS. All rights reserved.
//

import UIKit

class HolidaysCell: UICollectionViewCell {

    @IBOutlet weak var holidayDate: UIButton!

    override init(frame: CGRect) {
        super.init(frame: frame)

    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

    }

    override func awakeFromNib() {
        super.awakeFromNib()
        holidayDate.backgroundColor = UIColor.darkGray
        holidayDate.titleLabel?.textColor = UIColor.white
        holidayDate.isUserInteractionEnabled = false

    }

    func setData(text: String) {
        holidayDate.setTitle(text, for: .normal)
    }


    
}

