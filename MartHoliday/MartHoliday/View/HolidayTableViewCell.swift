//
//  HolidayTableViewCell.swift
//  MartHoliday
//
//  Created by YOUTH2 on 2018. 9. 20..
//  Copyright © 2018년 JINiOS. All rights reserved.
//

import UIKit

protocol DetailHeaderDelegate {
    func toggleHeader()
}

class HolidayTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!

    func setData(holiday: String) {
        dateLabel.text = holiday
    }

}


class HolidayHeaderCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    var delegate: DetailHeaderDelegate?

    @IBAction func moreButtonTapped(_ sender: Any) {
        delegate?.toggleHeader()
    }

    func set(holiday: String?) {
        dateLabel.text = holiday ?? "정보가 없습니다 :("
    }

}
