//
//  SettingTableViewCell.swift
//  MartHoliday
//
//  Created by YOUTH2 on 06/10/2019.
//  Copyright © 2019 JINiOS. All rights reserved.
//

import UIKit

class SettingTableViewCell: UITableViewCell {

    @IBOutlet weak var branchNameLabel: UILabel!

    var name: String? {
        didSet {
            guard let name = self.name else { return }
            branchNameLabel.text = name
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
