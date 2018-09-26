//
//  MainTableViewHeader.swift
//  MartHoliday
//
//  Created by YOUTH2 on 2018. 9. 26..
//  Copyright © 2018년 JINiOS. All rights reserved.
//

import UIKit

class MainTableViewHeader: UITableViewHeaderFooterView {
    @IBOutlet weak var nameLabel: UILabel!

    var name: String! {
        didSet {
            self.nameLabel.text = name
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
