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
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setData(branch: Branch) {
        setDateButton()
        self.branchTitle.text = branch.martType + branch.branchName + "의 휴무일"
        self.dateButton.setTitle(branch.holidays[0], for: .normal)
    }

    func setDateButton() {
        dateButton.contentEdgeInsets = UIEdgeInsets(top: 3, left: 5, bottom: 3, right: 5)
        dateButton.layer.cornerRadius = 7.0
        dateButton.clipsToBounds = true
        dateButton.backgroundColor = UIColor.lightGray
        dateButton.titleLabel?.textColor = UIColor.white
        dateButton.isUserInteractionEnabled = false
    }


}
