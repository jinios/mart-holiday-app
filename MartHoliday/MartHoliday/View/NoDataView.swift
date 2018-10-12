//
//  NoDataView.swift
//  MartHoliday
//
//  Created by YOUTH2 on 2018. 9. 28..
//  Copyright © 2018년 JINiOS. All rights reserved.
//

import UIKit

class NoDataView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = frame
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func setLabel(text: String) {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 50))
        label.attributedText = makeTextWithAttributes(of: text)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        self.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        label.widthAnchor.constraint(equalTo: self.widthAnchor, constant: 0.9).isActive = true
        label.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }

    private func makeTextWithAttributes(of myText: String) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let customAttributes = [NSAttributedStringKey.paragraphStyle: paragraphStyle,
                                NSAttributedStringKey.font: UIFont(name: "NanumSquareRoundOTF", size: self.frame.width * 0.05)?.bold(),
                                NSAttributedStringKey.foregroundColor: UIColor.appColor(color: .midgray),
                                ]
        let customText = NSAttributedString(string: myText,
                                            attributes: customAttributes)
        return customText
    }

}
