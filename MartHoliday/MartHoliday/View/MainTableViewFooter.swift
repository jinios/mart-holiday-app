//
//  MainTableViewFooter.swift
//  MartHoliday
//
//  Created by YOUTH2 on 2018. 9. 24..
//  Copyright © 2018년 JINiOS. All rights reserved.
//

import UIKit

class MainTableViewFooter: UIView {

    var sectionindex: Int?
    var delegate: FooterDelegate?
    var isExpanded: Bool?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
        button.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        button.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }

    lazy var button: UIButton = {
        let btn = UIButton(frame: CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.width, height: self.frame.height))
//        btn.setImage(UIImage(named: "downArrow"), for: .normal)
//        btn.setImage(UIImage(named: "upArrow"), for: .selected)
        btn.setArrowImage()
        btn.addTarget(self, action: #selector(click), for: .touchUpInside)
        return btn
    }()

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func click() {
        if let idx = sectionindex {
            delegate?.toggleFooter(index: idx)
        }
    }

    func setExpand(state: Bool) {
        self.button.isSelected = state
    }

}
