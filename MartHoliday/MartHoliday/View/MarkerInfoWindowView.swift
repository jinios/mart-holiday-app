//
//  MarkerInfoWindowView.swift
//  MartHoliday
//
//  Created by YOUTH2 on 15/06/2019.
//  Copyright © 2019 JINiOS. All rights reserved.
//

import UIKit
import NMapsMap

class MarkerInfoWindowDataSource: NSObject, NMFOverlayImageDataSource {

    var branch: Branch?

    func view(with overlay: NMFOverlay) -> UIView {
        let markerInfoView = MarkerInfoWindowView(branch: self.branch)
        return markerInfoView.make()
    }

}

class MarkerInfoWindowView: UIView {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var branchTitle: UILabel!
    var branch: Branch?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }

    convenience init(branch: Branch?) {
        self.init(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        self.branch = branch
    }

    private func commonInit() {
        Bundle.main.loadNibNamed("MarkerInfoWindowView", owner: self, options: nil)
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

    func make() -> UIView {
        self.branchTitle.text = self.branch?.displayName()
        self.contentView.layoutIfNeeded()
        return self.contentView
    }



}
