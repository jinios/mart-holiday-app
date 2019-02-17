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
        super.init(frame: .zero)
        Bundle.main.loadNibNamed("SlideMenuCellView", owner: self, options: nil)
        addSubview(content)
        content.frame = self.bounds
        content.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.imageView.clipsToBounds = true
        self.imageView.contentMode = .scaleAspectFit
    }

    func setData(menu: SlideMenu) {
        let menuData = menu.value
        self.titleLabel.text = menuData.title
        self.imageView.image = UIImage(named: menuData.imageName)
    }
}
