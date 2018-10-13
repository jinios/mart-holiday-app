//
//  MainTableViewCell.swift
//  MartHoliday
//
//  Created by YOUTH2 on 2018. 9. 26..
//  Copyright © 2018년 JINiOS. All rights reserved.
//

import Foundation

// dateCell
class MainTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!

    func setData(text: String) {
        self.selectionStyle = .none
        dateLabel.text = text
    }

}
