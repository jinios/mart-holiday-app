//
//  NoDataView.swift
//  MartHoliday
//
//  Created by YOUTH2 on 2018. 9. 28..
//  Copyright © 2018년 JINiOS. All rights reserved.
//

import UIKit

class NoDataView: UIView {

    let hapticGenerator = UIImpactFeedbackGenerator(style: .medium)

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = frame
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func setLabel(text: String) {

        let button = UIButton(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 50))
        button.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        button.setAttributedTitle(makeTextWithAttributes(of: text), for: .normal)
        self.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        button.widthAnchor.constraint(equalTo: self.widthAnchor, constant: 0.9).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }

    @objc func searchButtonTapped() {
        hapticGenerator.impactOccurred()
        NotificationCenter.default.post(name: .slideMenuTapped, object: nil, userInfo: ["next": SelectedSlideMenu.select])
    }

    private func makeTextWithAttributes(of myText: String) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let customAttributes = [NSAttributedString.Key.paragraphStyle: paragraphStyle,
                                NSAttributedString.Key.font: UIFont(name: "NanumSquareRoundOTF", size: self.frame.width * 0.05)?.bold(),
                                NSAttributedString.Key.foregroundColor: UIColor.appColor(color: .midgray),
                                ]
        let customText = NSAttributedString(string: myText,
                                            attributes: customAttributes)
        return customText
    }

}
