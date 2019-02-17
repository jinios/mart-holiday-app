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
    @IBOutlet weak var starButton: StarButton!
    let hapticGenerator = UIImpactFeedbackGenerator(style: .medium)
    var searchDelegate: SearchTextHighlighterDelegate?

    var branchData: Branch? {
        didSet {
            setTitle()
            setAddress()
            setStarButton()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        guard let branchData = self.branchData else { return }
        starButton.isSelected = branchData.favorite
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func starButtonTapped(_ sender: Any) {
        toggleState()
    }

    private func setTitle() {
        guard let branchData = self.branchData else { return }
        self.title.partialBackgroundChange(fullText: branchData.branchName, changeText: searchDelegate?.text ?? "")
    }

    private func setAddress() {
        guard let branchData = self.branchData else { return }
        self.address.partialBackgroundChange(fullText: branchData.address, changeText: searchDelegate?.text ?? "")
    }

}

extension BranchTableViewCell: FavoriteTogglable {
    func toggleState() {
        guard let branchData = self.branchData else { return }
        guard branchData.toggleFavorite() else { return }
        self.starButton.toggleState()
        hapticGenerator.impactOccurred()
    }

    func setStarButton() {
        guard let branchData = self.branchData else { return }
        starButton.isSelected = branchData.favorite
    }

}

