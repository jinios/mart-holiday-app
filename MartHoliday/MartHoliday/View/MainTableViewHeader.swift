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
    @IBOutlet weak var containerView: UIView!

    var sectionIndex: Int?
    var delegate: HeaderDelegate?
    
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

    @IBAction func headerButtonTapped(_ sender: Any) {
        self.containerView.backgroundColor = UIColor.appColor(color: .mint)
        delegate?.selectHeader(index: sectionIndex!)
    }

    override func prepareForReuse() {
        self.containerView.backgroundColor = UIColor.white
    }

}
