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
        self.star.imageView?.image = UIImage(named: "emptyStar")
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
        DispatchQueue.main.async {
            guard let branchData = self.branchData else { return }

            switch branchData.favorite {
            case true : self.star.imageView?.image = UIImage(named: "yellowStar")
            case false : return
            }
        }
    }

}
