//
//  NoMapView.swift
//  MartHoliday
//
//  Created by YOUTH2 on 2018. 10. 2..
//  Copyright © 2018년 JINiOS. All rights reserved.
//

import UIKit

protocol AddressCopiable {
    var noMapView: UIView? { get }
    func copyAddress()
}

class NoMapView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var copyButton: UIButton!
    var delegate: AddressCopiable!

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func loadFromXib() {
        Bundle.main.loadNibNamed("NoMapView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        setButtonTextAttributes(text: "주소복사하기 ✏️")
    }

    private func setButtonTextAttributes(text: String) {
        copyButton.setAttributedTitle(makeTextWithAttributes(of: text), for: .normal)
    }

    @IBAction func copyButtonTapped(_ sender: Any) {
        delegate.copyAddress()
    }

    private func makeTextWithAttributes(of myText: String) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let customAttributes = [NSAttributedStringKey.paragraphStyle: paragraphStyle,
                                NSAttributedStringKey.font: UIFont(name: "NanumSquareRoundOTF", size: self.frame.width * 0.05),
//                                NSAttributedStringKey.foregroundColor: UIColor.appColor(color: .midgray),
                                ]
        let customText = NSAttributedString(string: myText,
                                            attributes: customAttributes)
        return customText
    }

}


