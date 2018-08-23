//
//  FavoriteCell.swift
//  MartHoliday
//
//  Created by YOUTH2 on 2018. 8. 23..
//  Copyright © 2018년 JINiOS. All rights reserved.
//

import Foundation

class FavoriteCell: UICollectionViewCell {

    @IBOutlet weak var title: RoundedEdgeLabel!
    @IBOutlet var holidayLabels: [RoundedEdgeLabel]!


    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = UIColor.white
    }

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    func setData(branch: Branch) {
        title.text = "\(branch.martType) \(branch.branchName)"
        for i in 0..<branch.holidays.count {
            holidayLabels[i].text = branch.holidays[i]
        }
    }

}


class RoundedEdgeLabel: UILabel {

    init() {
        super.init(frame: CGRect.zero)
        self.adjustsFontSizeToFitWidth = true
        setup()
    }

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: 2, left: 8, bottom: 5, right: 8)
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func setup() {
        self.backgroundColor = UIColor.black
        self.textColor = UIColor.white
        self.textAlignment = .center
        layer.cornerRadius = frame.height / 7
        clipsToBounds = true
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setup()
    }

}

