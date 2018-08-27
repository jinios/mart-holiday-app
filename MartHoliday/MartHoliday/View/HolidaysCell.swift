//
//  HolidaysCell.swift
//  MartHoliday
//
//  Created by YOUTH2 on 2018. 8. 25..
//  Copyright © 2018년 JINiOS. All rights reserved.
//

import UIKit

class HolidaysCell: UICollectionViewCell {

    @IBOutlet weak var holidayDate: UIButton!

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        holidayDate.titleEdgeInsets = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
        holidayDate.layer.cornerRadius = 7.0
        holidayDate.clipsToBounds = true
        holidayDate.backgroundColor = UIColor.darkGray
        holidayDate.titleLabel?.textColor = UIColor.white
        holidayDate.isUserInteractionEnabled = false
    }

    func setData(text: String) {
        holidayDate.setTitle(text, for: .normal)
        holidayDate.setAttributedTitle(self.makeTextWithAttributes(of: text), for: .normal)
    }

    private func makeTextWithAttributes(of myText: String) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center

        let customAttributes = [NSAttributedStringKey.paragraphStyle: paragraphStyle,
                                NSAttributedStringKey.font: UIFont(name: "NanumSquareRoundOTF", size: self.frame.width * 0.12)?.bold(),
                                NSAttributedStringKey.foregroundColor: UIColor.white,
        ]
        let customText = NSAttributedString(string: myText,
                                            attributes: customAttributes)
        return customText
    }
    
}

extension UIFont {
    func bold() -> UIFont {
        let desc = self.fontDescriptor.withSymbolicTraits(.traitBold)
        return UIFont(descriptor: desc!, size: self.pointSize)
    }
}



