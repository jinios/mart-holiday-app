//
//  SelectionTableViewCell.swift
//  MartHoliday
//
//  Created by YOUTH2 on 2018. 9. 6..
//  Copyright © 2018년 JINiOS. All rights reserved.
//

import UIKit

class SelectionTableViewCell: UITableViewCell {

    @IBOutlet weak var martImage: UIImageView!
    var data: CIImageHolder?
    let cornerRadius: CGFloat = 15.0

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor(named: "mh-lightgray")
        martImage.contentMode = .scaleAspectFill
        martImage.clipsToBounds = true
    }

    func setImage() {
        guard let data = self.data else { return }
        martImage.image = UIImage(named: data.grayImageName)
        martImage.highlightedImage = UIImage(named: data.imageName)
    }

}
