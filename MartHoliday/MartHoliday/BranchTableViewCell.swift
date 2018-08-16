//
//  BranchTableViewCell.swift
//  MartHoliday
//
//  Created by YOUTH2 on 2018. 8. 12..
//  Copyright © 2018년 JINiOS. All rights reserved.
//

import UIKit

class BranchTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var star: UIButton!

    var branchData: Branch? {
        didSet {
            setTitle()
            setAddress()
            setStar()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func prepareForReuse() {
        guard let branchData = self.branchData else { return }
        star.isSelected = branchData.favorite
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    private func setTitle() {
        guard let branchData = self.branchData else { return }
        self.title.text = branchData.branchName
    }

    private func setAddress() {
        guard let branchData = self.branchData else { return }
        self.address.text = branchData.address
    }

    private func setStar() {
        guard let branchData = self.branchData else { return }
        star.isSelected = branchData.favorite
        star.setStarIconImage()
    }

}
