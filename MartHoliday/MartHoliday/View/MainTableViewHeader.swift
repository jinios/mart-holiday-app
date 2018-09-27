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
    @IBOutlet weak var arrowButton: UIButton!

    var name: String! {
        didSet {
            self.nameLabel.text = name
        }
    }

    var branch: Branch! {
        didSet {
            self.nameLabel.text = branch.displayName()
        }
    }

    @IBOutlet weak var containerView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        arrowButton.showsTouchWhenHighlighted = true
    }

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    @IBAction func headerButtonTapped(_ sender: Any) {
        self.containerView.backgroundColor = UIColor(named: AppColor.mint.description)
    }

    override func prepareForReuse() {
        self.containerView.backgroundColor = UIColor.white
    }


}
