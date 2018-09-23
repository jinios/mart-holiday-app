//
//  TodayExtensionTableViewCell.swift
//  MartHolidayTodayExtension
//
//  Created by YOUTH2 on 2018. 9. 15..
//  Copyright © 2018년 JINiOS. All rights reserved.
//

import UIKit

class TodayExtensionTableViewCell: UITableViewCell {
    @IBOutlet weak var branchTitle: UILabel!
    @IBOutlet weak var dateButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    func setData(branch: Branch) {
        setDateButton()
        self.branchTitle.text = branch.martName() + " " + branch.branchName
        guard let holiday = branch.holidays.first else {
            self.dateButton.setTitle("정보가 없습니다:(", for: .normal)
            return
        }
        self.dateButton.setTitle(holiday, for: .normal)
    }

    func setDateButton() {
        dateButton.contentEdgeInsets = UIEdgeInsets(top: 3, left: 5, bottom: 3, right: 5)
        dateButton.layer.cornerRadius = 7.0
        dateButton.clipsToBounds = true
        dateButton.backgroundColor = UIColor(named: "mh-navy")
        dateButton.titleLabel?.textColor = UIColor.white
        dateButton.isUserInteractionEnabled = false
    }


}
