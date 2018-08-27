//
//  SlideMenuCell.swift
//  MartHoliday
//
//  Created by YOUTH2 on 2018. 8. 18..
//  Copyright © 2018년 JINiOS. All rights reserved.
//

import UIKit

class SlideMenuCell: UICollectionViewCell {

    @IBOutlet var content: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var imageView: UIImageView!


    override init(frame: CGRect) {
        super.init(frame: frame)
        Bundle.main.loadNibNamed("SlideMenuCellView", owner: self, options: nil)
        addSubview(content)
        content.frame = self.bounds
        content.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.imageView.clipsToBounds = true
        self.imageView.contentMode = .scaleAspectFit
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setData(menu: MenuData) {
        self.titleLabel.text = menu.title
        self.imageView.image = UIImage(named: menu.imageName)
    }
}