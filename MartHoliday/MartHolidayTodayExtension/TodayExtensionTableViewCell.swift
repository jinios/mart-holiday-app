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
        self.branchTitle.text = branch.martType + branch.branchName
//        self.dateButton.titleLabel?.text = branch.holidays[0]
        self.dateButton.setTitle(branch.holidays[0], for: .normal)
    }

}
