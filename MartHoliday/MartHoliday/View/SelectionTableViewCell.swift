//
//  SelectionTableViewCell.swift
//  MartHoliday
//
//  Created by YOUTH2 on 2018. 9. 6..
//  Copyright © 2018년 JINiOS. All rights reserved.
//

import UIKit

class SelectionTableViewCell: UITableViewCell {

    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var martImage: UIImageView!
    var data: CIImageHolder?
    let cornerRadius: CGFloat = 10.0

    override func awakeFromNib() {
        super.awakeFromNib()
        martImage.contentMode = .scaleAspectFit
        martImage.backgroundColor = UIColor.clear
        martImage.layer.cornerRadius = cornerRadius
        martImage.layer.borderWidth = 1.0
        martImage.layer.borderColor = UIColor.clear.cgColor
        martImage.clipsToBounds = true
        
        outerView.layer.shadowColor = UIColor.lightGray.cgColor
        outerView.layer.shadowOffset = CGSize(width:0,height: 2.0)
        outerView.layer.cornerRadius = cornerRadius
        outerView.layer.shadowRadius = 2.0
        outerView.layer.shadowOpacity = 1.0
        outerView.layer.masksToBounds = false
    }

    func setImage() {
        guard let data = self.data else { return }
        martImage.image = UIImage(named: data.imageName)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
