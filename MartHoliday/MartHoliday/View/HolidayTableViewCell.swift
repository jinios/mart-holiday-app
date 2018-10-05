//
//  HolidayTableViewCell.swift
//  MartHoliday
//
//  Created by YOUTH2 on 2018. 9. 20..
//  Copyright © 2018년 JINiOS. All rights reserved.
//

import UIKit

class HolidayTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!

    func setData(holiday: String) {
        dateLabel.text = holiday
    }

}
