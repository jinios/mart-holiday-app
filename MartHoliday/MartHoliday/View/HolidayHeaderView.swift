//
//  HolidayHeaderView.swift
//  MartHoliday
//
//  Created by YOUTH2 on 2018. 10. 1..
//  Copyright © 2018년 JINiOS. All rights reserved.
//

import UIKit

class HolidayHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var selectionDetectView: UIView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    var delegate: HeaderDelegate?

    func set(holiday: String?) {
        dateLabel.text = holiday ?? "정보가 없습니다 :("
        setButton()
    }

    private func setButton() {
        button.setImage(UIImage(named: "downArrow"), for: .normal)
        button.setImage(UIImage(named: "upArrow"), for: .selected)
    }

    @IBAction func tapButton(_ sender: Any) {
        delegate?.selectHeader(index: 0)
    }

    func setExpand(state: Bool) {
        self.button.isSelected = state
        self.selectionDetectView.isHidden = !state
    }

}
